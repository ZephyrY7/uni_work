const int R1=8;
const int Y1=9;
const int G1=10;
const int R2=7;
const int Y2=6;
const int G2=5;

const int TrigEchoPinJ1 = 12;
const int TrigEchoPinJ2 = 11;

const int P1=2;
const int PR=4;
const int PG=3;

// provides checking of J1 when starting simulation
int LoopJ1 = 1;
int skip = 0;


long durationtodistance(long microseconds){
  	// convert duration in microseconds to distance in centimeters
  return microseconds*0.034/2;
}


long readUltrasonicSensor(int TrigPin, int EchoPin){
  long duration, cm;
  	//clear trigger pin
  pinMode(TrigPin,OUTPUT); 
  digitalWrite(TrigPin,LOW);
  delayMicroseconds(2);
  	//set trigger pin as HIGH to get input
  digitalWrite(TrigPin,HIGH);
  delayMicroseconds(10);
  digitalWrite(TrigPin,LOW);
  pinMode(EchoPin,INPUT);
  	//reads data and return
  duration = pulseIn(EchoPin,HIGH);
  cm = durationtodistance(duration);
  return cm;
}
 
int J1Go(int waitTime1, int waitTime2){
  	// green light for J1 and red light for J2
  digitalWrite(G1,HIGH);
  digitalWrite(G2,LOW);
  digitalWrite(R1,LOW);
  digitalWrite(R2,HIGH);
  digitalWrite(PR,HIGH);
  digitalWrite(PG,LOW);
  delay(waitTime1);
  	// read J2 distance, return if does not have vehicle detect
  if (readUltrasonicSensor(TrigEchoPinJ2, TrigEchoPinJ2)>320){ 
    return 1;
  }else if (skip == 1){
  	return 1; 
  }
  	// yellow light for J1
  digitalWrite(R1,LOW);
  digitalWrite(G1,LOW);
  digitalWrite(Y1,HIGH);
  delay(waitTime2);
  	// reset lights
  digitalWrite(R2,LOW);
  digitalWrite(Y1,LOW);
  return 0;
}

int J2Go(int waitTime1, int waitTime2){
  	// green light for J2 and red light for J1
  int distanceJ1;
  digitalWrite(G2,HIGH);
  digitalWrite(G1,LOW);
  digitalWrite(R2,LOW);
  digitalWrite(R1,HIGH);
  digitalWrite(PR,HIGH);
  digitalWrite(PG,LOW);
  delay(waitTime1);
  	// read J1 distance, return if does not have vehivle detect
  if (readUltrasonicSensor(TrigEchoPinJ1, TrigEchoPinJ1)>320){
  	return 0;
  }else if (skip == 1){
  	return 1; 
  }
  	// yellow light for J2
  digitalWrite(R2,LOW);
  digitalWrite(G2,LOW);
  digitalWrite(Y2,HIGH);
  delay(waitTime2);
  	// reset lights
  digitalWrite(R1,LOW);
  digitalWrite(Y2,LOW);
  return 1;
}

void setup()
{
  	// define output pins
  pinMode(R1,OUTPUT);
  pinMode(Y1,OUTPUT);
  pinMode(G1,OUTPUT);
  pinMode(R2,OUTPUT);
  pinMode(Y2,OUTPUT);
  pinMode(G2,OUTPUT);
  	//begin serial for easier debug
  Serial.begin(9600);
  
  pinMode(PR,OUTPUT);
  pinMode(PG,OUTPUT);
  pinMode(P1,INPUT);
  attachInterrupt(digitalPinToInterrupt(P1), pedestrian, CHANGE);

}

void loop()
{
  int distanceJ1, distanceJ2;
  int T1 = 5000;
  int T2 = 500;
  digitalWrite(PR,HIGH);
  skip = 0;
  	//update distance of J1
  distanceJ1 = readUltrasonicSensor(TrigEchoPinJ1,TrigEchoPinJ1);
  
  	//serial print the output of ultrasonic sensor
  Serial.print(String("DistanceJ1: ") + distanceJ1 + String("cm\n"));
  
  	// only run when 1st time and when J1 have vehicle
  if(LoopJ1 == 1){
    	// run when J1 have vehicle
    if (distanceJ1>0 && distanceJ1<=100){
    	LoopJ1 = J1Go(T1, T2);
  	}else if (distanceJ1>100 && distanceJ1<=200){
   		LoopJ1 = J1Go(T1*1.5, T2*1.5);
  	}else if (distanceJ1>200 && distanceJ1<=320){
    	LoopJ1 = J1Go(T1*2, T2*2);
  	}else{
  		digitalWrite(R1,HIGH);
    	digitalWrite(Y1,LOW);
    	digitalWrite(G1,LOW);
    }
  }
  skip = 0;
  	// update distance of J2
  distanceJ2 = readUltrasonicSensor(TrigEchoPinJ2,TrigEchoPinJ2);
  Serial.print(String("DistanceJ2: ") + distanceJ2 + String("cm\n"));
  	// run when J2 have vehicle detected
  if (distanceJ2>0 && distanceJ2<=100){
    LoopJ1 = J2Go(T1, T2);
  }else if (distanceJ2>100 && distanceJ2<=200){
   	LoopJ1 = J2Go(T1*1.5, T2*1.5);
  }else if (distanceJ2>200 && distanceJ2<=320){
    LoopJ1 = J2Go(T1*2, T2*2);
  }else{
  	digitalWrite(R2,HIGH);
    digitalWrite(Y2,LOW);
    digitalWrite(G2,LOW);
  	// check if J1 have vehicle and enable the flag
    if (distanceJ1>0 && distanceJ1<=320){
  	LoopJ1 = 1; 
    }
  } 
  
}

void pedestrian(){
    Serial.print(String("\n Interrupted \n"));
    delay(50000);
    digitalWrite(R1,HIGH);
    digitalWrite(Y1,LOW);
    digitalWrite(G1,LOW);
    digitalWrite(R2,HIGH);
    digitalWrite(Y2,LOW);
    digitalWrite(G2,LOW);
    
    digitalWrite(PG,HIGH);
    digitalWrite(PR,LOW);
    delay(10000);
    skip = 1;
}