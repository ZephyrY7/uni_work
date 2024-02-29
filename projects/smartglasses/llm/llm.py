if __name__ == '__main__':

    from llama_cpp.llama import Llama
    # import torch
    import json
    import os
    import re
    import paho.mqtt.client as mqtt
    import paho.mqtt.publish as publish
    from RealtimeSTT import AudioToTextRecorder
    import math

    output = ""
    query = ""
    history = []
    functions = [
        {
            "name": "Selection the correct type of information (dimension, image and data of room) based on user requirements",
            "api_name": "get_info",
            "description": "Select suitable required information for given user query and the information needed (dimension, image, data) as parameters",
            "parameters":  [
                {"name": "type", "enum": ["dimension", "image", "data"], "description": "Select the type of information needed based on user requirement"},
                {"name": "des", "description": "Repeat the user question."}
            ]
        }
    ]
    
    ## Parameters
    def replace_placeholders(params, char, user, scenario = ""):
        for key in params:
            if isinstance(params[key], str):
                params[key] = params[key].replace("{char}", char)
                params[key] = params[key].replace("{user}", user)
                if scenario:
                    params[key] = params[key].replace("{scenario}", scenario)
        return params

    with open('llm_test\\config\\creation_params.json') as f:
        creation_params = json.load(f)
    with open('llm_test\\config\\completion_params.json') as f:
        completion_params = json.load(f)
    with open('llm_test\\config\\chat_params.json') as f:
        chat_params = json.load(f)

    chat_params = replace_placeholders(chat_params, chat_params["char"], chat_params["user"])
    chat_params = replace_placeholders(chat_params, chat_params["char"], chat_params["user"], chat_params["scenario"])

    if not completion_params['logits_processor']:
        completion_params['logits_processor'] = None

    ## Functions
    def write_file(file_path, content, mode='w'):
        with open(file_path, mode) as f:
            f.write(content)

    write_file("./llm_test/temp/user_responses.txt", "")

    def append_file(file_path, content, mode='a'):
        with open(file_path, mode) as f:
            f.write(content)

    def clear_console():
        os.system('clear' if os.name == 'posix' else 'cls')

    def encode(string):
        return model_chat.tokenize(string.encode() if isinstance(string, str) else string)
    
    def count_tokens(string):
        return len(encode(string))

    # Generate conversational prompt
    def create_prompt():
        
        prompt = f'<|system|>\n{chat_params["system_prompt"]}</s>\n'
        
        if chat_params["initial_message"]:
            prompt += f"<|assistant|>\n{chat_params['initial_message']}</s>\n"

        return prompt + "".join(history) + "<|assistant|>"
    
    # Generate function prompt
    def get_function_prompt(user_query: str, functions: list = []) -> str:
        """
        Generates a conversation prompt based on the user's query and a list of functions.

        Parameters:
        - user_query (str): The user's query.
        - functions (list): A list of functions to include in the prompt.

        Returns:
        - str: The formatted conversation prompt.
        """
        if len(functions) == 0:
            return f"USER: <<question>> {user_query}\nASSISTANT: "
        functions_string = json.dumps(functions)
        return f"USER: <<question>> {user_query} <<function>> {functions_string}\nASSISTANT: "

    def generate():
        global output
        output = ""
        prompt = create_prompt()
        write_file('llm_test\\temp\\last_prompt.txt', prompt)

        #print(prompt)
        completion_params['prompt'] = prompt
        first_chunk = True
        for completion_chunk in model_chat.create_completion(**completion_params):
            text = completion_chunk['choices'][0]['text']
            if first_chunk and text.isspace():
                continue
            first_chunk = False
            output += text
            yield text

    # parse when list of sentence is given from llm
    def parse_sentence(sentence):
        # Define the pattern for matching each item in the list
        pattern = re.compile(r'\d+\.\s([^\d]+)')

        # Use findall to extract all matches
        matches = pattern.findall(sentence)

        # If no matches are found, return the original sentence
        if not matches:
            return sentence, 0

        return matches, 1

    # Function caller
    def execute_function(func_in):
        try:
            eval(func_in)
            # return result
        except Exception as e:
            return 0
    
    # Sends signal to esp and run functions
    mqtt_server = "<IPADDRESS>"  # MQTT broker's IP address or hostname
    mqtt_port = "<PORT>"

    # Subcribe to MQTT server to get feedback 
    def on_connect(client, userdata, flags, rc):
        print("Connected with result code "+str(rc))
        client.subscribe("esp32/data")      # for esp feedback
        client.subscribe("cam/data")      # for cam feedback
        client.subscribe("esp32/measure")

    received_message = ""

    def on_message(client, userdata, msg):
        global received_message 
        received_message = msg.payload.decode()

         # Check which topic the message is from
        if msg.topic == "esp32/data":
            if received_message == "function executed":
                print("Shutting down the server...")
                client.disconnect()  # Disconnect from the MQTT broker
            # Do something specific for this topic
            print("Message from topic 'esp32/data': " + received_message)

        elif msg.topic == "cam/data":

            if received_message == "Captured":

                print("Message from topic 'cam/data': " + received_message)
                client.disconnect()

            print("Message from topic 'cam/data': " + received_message)

            client.disconnect()

        elif msg.topic == "esp32/measure":
            print("Message from topic 'measure/data': " + received_message)

            client.disconnect()
            

        # elif msg.topic == "stt/output":
        #     # Handle messages from topic "esp32/data2"
        #     # Do something specific for this topic
        #     print("Message from topic 'esp32/data2': " + received_message)
        #     print("\nShutting down the server...")
        #     client.disconnect()  # Disconnect from the MQTT broker
        # else:
            # Handle messages from other topics
            # print("Message from an unknown topic: " + received_message)

    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message

    def mqtt_wait():
        client.connect(mqtt_server, mqtt_port, 60)
        client.loop_forever()

    def split_publish_message(message):
        max_chunk_size = 200

        # Check if the message is longer than the maximum chunk size
        # if len(message) > max_chunk_size:
        chunks = [message[i:i + max_chunk_size] for i in range(0, len(message), max_chunk_size)]

        for chunk in chunks:
            publish.single("python/print", chunk, hostname=mqtt_server, port=mqtt_port)
            # check whether the functions executed completely on the ESP32
            mqtt_wait()
            #print(f"Published: {chunk}")

        return

    user_in_flag = 1
    # Image / Dimension / Data

    def image_init(message):
        global received_message
        split_publish_message(message)
        while True:
            print(f'\n>>> {chat_params["user"]}: ', end="", flush=True)
            print(f'{(user_text := recorder.text())}\n<<< {chat_params["char"]}: ', end="", flush=True)
            #user_text = input()
            split_publish_message(user_text)

            if "capture image" in user_text.lower():
                #split_publish_message(user_text)
                publish.single("python/image", "Capture", hostname=mqtt_server, port=mqtt_port)
                mqtt_wait()
                #publish.single("python/imagecap","Image Captured... Thanks for sending image! Please wait...", hostname=mqtt_server, port=mqtt_port)
                split_publish_message(received_message)

            if "last image" in user_text.lower():
                #split_publish_message(user_text)
                publish.single("python/image", "Capture Last", hostname=mqtt_server, port=mqtt_port)
                #publish.single("python/imagecap","Image Captured... Thanks for sending image! Please wait...", hostname=mqtt_server, port=mqtt_port)
                mqtt_wait()
                split_publish_message(received_message)
                mqtt_wait()
                #history.append(f"<|user|>\nExisting Electrical Wiring/Appliances: {received_message}</s>\n")
                append_file('llm_test\\temp\\user_responses.txt', f"<|user|>\nExisting Electrical Wiring/Appliances: {received_message}</s>\n")
                break

    def polar_distance(r1, theta_x1, theta_y1, theta_z1, r2, theta_x2, theta_y2, theta_z2):
        # Convert angles from degrees to radians
        theta_y1_rad = math.radians(theta_y1)
        theta_z1_rad = math.radians(theta_z1)
        theta_y2_rad = math.radians(theta_y2)
        theta_z2_rad = math.radians(theta_z2)

        # Calculate distance in polar coordinates
        distance = math.sqrt(
            (r2 * math.sin(theta_y2_rad) * math.cos(theta_z2_rad) - r1 * math.sin(theta_y1_rad) * math.cos(theta_z1_rad))**2 +
            (r2 * math.sin(theta_y2_rad) * math.sin(theta_z2_rad) - r1 * math.sin(theta_y1_rad) * math.sin(theta_z1_rad))**2 +
            (r2 * math.cos(theta_y2_rad) - r1 * math.cos(theta_y1_rad))**2
        )

        return distance

    def get_info(**kwargs):
        if kwargs['type'] == "image":
            print(f'\n\nImage needed: {kwargs["des"]}', end="\n", flush=True)
            message = f'Image needed: {kwargs["des"]}'
            split_publish_message(message)

            while True:
                print(f'\n>>> {chat_params["user"]}: ', end="", flush=True)
                print(f'{(user_text := recorder.text())}\n<<< {chat_params["char"]}: ', end="", flush=True)
                #user_text = input()
                split_publish_message(user_text)

                if "capture" in user_text.lower():
                    split_publish_message(user_text)
                    break
            publish.single("python/image", "Capture", hostname=mqtt_server, port=mqtt_port)
            split_publish_message("Image Captured... Thanks for sending image! Please wait...")

            print("\nImage Captured... Thanks for sending image!")
            mqtt_wait()
            split_publish_message("Please provide a description to the captured image...")
            print("\nPlease provide a description to the captured image...")
            print(f'\n>>> {chat_params["user"]}: ', end="", flush=True)
            print(f'{(user_text := recorder.text())}\n<<< {chat_params["char"]}: ', end="", flush=True)
            #user_text = input()
            split_publish_message(user_text)
            # append description to history
            history.append(f"<|user|>\nImage Sent. {user_text}</s>\n")
            append_file('llm_test\\temp\\user_responses.txt', f"<|user|>\n{user_text}</s>\n")
            user_in_flag = 0

            print(received_message)

            #print(response)
        elif kwargs['type'] == "dimension":
            
            measurement_points = []
            all_coordinates = []
            calculated_distances = []

            print(f'\n\n Dimension needed: {kwargs["des"]}', end="\n", flush=True)
            message = f'Dimension needed: {kwargs["des"]}'
            split_publish_message(message)

            while True:
                print(f'\n>>> {chat_params["user"]}: ', end="", flush=True)
                print(f'{(user_text := recorder.text())}\n<<< {chat_params["char"]}: ', end="", flush=True)
                #user_text = input()
                split_publish_message(user_text)

                if "capture dimension" in user_text.lower():
                    
                    publish.single("python/measure", "Capture", hostname=mqtt_server, port=mqtt_port)
                    mqtt_wait()
                    measurement_points.append(received_message)
                    split_publish_message("Points captured...")
                    
                elif "capture the last dimension" in user_text.lower():
                    split_publish_message("Thanks for capturing the dimension for us... Please wait while we calculate the points distance...")
                    publish.single("python/measure", "Capture", hostname=mqtt_server, port=mqtt_port)
                    mqtt_wait()
                    measurement_points.append(received_message)
                    #send all captured image to algorithms
                    # Iterate over each texts that contains data
                    for text in measurement_points:
                        # Use regular expressions to extract numerical values
                        matches = re.findall(r'-?\d+(?:\.\d+)?', text)
                        # Convert the matched values to floats and store in an array
                        coordinates = [float(match) for match in matches]
                        # Append the array to the list
                        all_coordinates.append(coordinates)
                    # Calculate the distance between each 2 points
                    for i in range(len(all_coordinates) - 1):
                        point1 = all_coordinates[i]
                        point2 = all_coordinates[i + 1]
                        distance = polar_distance(*point1, *point2)
                        print(f"Distance between point {i + 1} and point {i + 2}: {distance}")
                        calculated_distances.append(f"{distance:.2f} cm")

                    result_string = ", ".join(calculated_distances)
                    print(f"Dimensions: {result_string}")
                    
                    history.append(f"<|user|>\nDimension measured. {result_string}</s>\n")
                    append_file('llm_test\\temp\\user_responses.txt', f"<|user|>\nDimension measured. {result_string}</s>\n")

                    user_in_flag = 0
                    break
                    
            #print(response)
        elif kwargs['type'] == "data":
            print(f'\n\n{kwargs["des"]}', end="\n", flush=True)
            message = f'{kwargs["des"]}'
            split_publish_message(message)
            user_in_flag = 1

    # Initialize AI Model
    print("Initializing Zephyr ...")
    model_chat = Llama(**creation_params)
    print("Zephyr initialized!")
    print("Initializing Gorilla ...")
    model_function = Llama("C:\\Users\\zephyr\\Documents\\projects\\gdp\\llm_test\\models\\gorilla-openfunctions-v1.Q4_K_M.gguf", seed=0, verbose = False)
    print("Gorilla initialized")
    print("Initializing Whisper STT ...")
    recorder = AudioToTextRecorder(model="base.en", language="en", spinner=False, post_speech_silence_duration = 1.5, wake_words="hey google")
    print("Whisper STT initialized ...")

    # Get requirements first
    msg_init = f'{chat_params["initial_message"]}\nNow Please let me know your requirement (any electrical installation)\n'
    print(msg_init)
    split_publish_message(msg_init + f'Before we start, I would need you to take some pictures...')
    image_init("Please capture your existing electrical panel such as circuit breakers or any electrical appliances.")

    split_publish_message("Now Please let me know your requirement (any electrical installation.")
    print("Now Please let me know your requirement (any electrical installation.")
    # Collection of information via conversation
    while True:
        if user_in_flag == 1:
            print(f'\n>>> {chat_params["user"]}: ', end="", flush=True)
            print(f'{(user_text := recorder.text())}\n<<< {chat_params["char"]}: ', end="", flush=True)
            #user_text = input()
            split_publish_message(user_text)

            # print(f'{(user_text := recorder.text())}\n<<< {chat_params["char"]}: ', end="", flush=True)
            history.append(f"<|user|>\n{user_text}</s>\n")
            append_file('llm_test\\temp\\user_responses.txt', f"<|user|>\n{user_text}</s>\n")

        tokens_history = count_tokens(create_prompt())
        while tokens_history > 8192 - 500:
            history.pop(0)
            history.pop(0)
            tokens_history = count_tokens(create_prompt())

        #print(f'\n<<< {chat_params["char"]}: ', end="", flush=True)
        for text in generate():
            pass
            # print(f'{text}', end="", flush=True)
            #history.append(f"\n{text}</s>\n")
        #print('\n')
        user_in_flag = 1
        history.append(f"<|assistant|>\n{output}</s>\n")
        write_file('llm_test\\temp\\last_prompt.txt', create_prompt())
        query, f_call = parse_sentence(output)
        # print(query + [f_call])
        if f_call == 1:
            for query in query:

                function_prompt = get_function_prompt(query, functions=functions)
                function_response = model_function(
                                        function_prompt,
                                        max_tokens = 200,
                                        )
                #print(function_response['choices'][0]['text'])
                #print(query)
                f_call_success = execute_function(function_response['choices'][0]['text'])
                #print(f_call_success)
                if f_call_success == 0:
                    get_info(type="data", des=query)
        elif f_call == 0:
            get_info(type="data", des=query)
