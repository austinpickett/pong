/* Author: Austin Pickett
 * Date: 04/15/12
 * Desc: Pong game in processing.
 * ToDo: 
 *        - sine() &  cos() angles on paddle hit
 *        - 10 minute / score 10 game time
 */

//init scores
int p1score, p2score;

// set width and height
int width=screen.width/2;
int height=screen.height/2;

// set x, y, radius for ball.
int x = width/2;
int y = height/2;
int radius = 10;

int paddleHeight = 100, paddleWidth = 10;
int leftY = (height/2)-(paddleHeight/2);
int rightY = (height/2)-(paddleHeight/2);

float speed=3; // init speed.

int timeStart = 9; // set for 10 mins

Paddle p1, p2;
Ball ball;
Timer time;

int pause=-1;
int saveTime;

void setup(){
  size(width,height);
  
  // create the paddles
  p1 = new Paddle(paddleWidth/2,leftY+paddleHeight, leftY, paddleWidth);
  p1.setActive();
  p2 = new Paddle(width-(paddleWidth/2),rightY+paddleHeight, rightY, paddleWidth);
  ball = new Ball(radius,x,y,speed,speed);
  time = new Timer(timeStart);

}

// Pause when Pressed.
void mousePressed() {
  stop();
}

void displayBG(){ 
  background(0);
  text("Player 1:" +p1score,(width/2)-100,10);
  text("Player 2:" +p2score,(width/2)+50,10);
  
  strokeWeight(1);
  // display dotted line  
  int xLine = width/2;
  int y1 = 0;
  int y2 = height;
  for(int i=0; i<=y2; i++) {
    float x = lerp(xLine, xLine, i/50.0);
    float y = lerp(y1, y2, i/50.0);
    point(x, y);
  }
  time.displayTime();
}
void stop(){
    pause*=-1;
    saveTime = time.getTime();
}
void draw() {
  time.setTime(saveTime);
  if(pause<0) {
    
    displayBG();
    
    p1.display();
    p1.move();

    p2.display();
    p2.move();

    ball.display();
    ball.move();
    collide();
  }
}

// paddle collision
void collide() {
  if ((ball.x<=p1.x+9) && (ball.y<p1.y1) && (ball.y>p1.y2)) {
    ball.collide();
  }
  if ((ball.x>=p2.x-9) && (ball.y<p2.y1) && (ball.y>p2.y2)){
    ball.collide();
  }
}

// detect left & right two switch paddles
void keyPressed() {
 switch(keyCode){
  case LEFT:
    p1.setActive();
    p2.setInactive();
    break;
  case RIGHT:
    p2.setActive();
    p1.setInactive();
    break; 
  case 32: //spacebar
    stop();
    break;
 }
}

/* Timer Class */
class Timer {
  int climit, c; //time

  Timer(int climit) {
    this.climit = climit;
  }

  // convert millis to seconds
  int getSec(int c){
    return c/(1000)%60;
  }
  int getMin(int c){
    return c/(60*1000);
  }
  void setTime(int mili){
    c = (climit*60*1000)-millis()-mili;
  }
  int getTime() {
    return c;
  }
  void displayTime() {
    getTime();
    // format the text
    text(nf(getMin(c),2)+":"+nf(getSec(c),2),(width/2)-15,20);
  }
}

/* Ball Class */
class Ball {
  // init vars
  int radius, x, y;
  float ax, ay;
  Ball(int radius, int x, int y, float ax, float ay){
    this.radius = radius;
    this.x = x;
    this.y = y;
    this.ax=ax;
    this.ay=ay;
  }

  void display() {
    fill(255);
    ellipse(x,y,radius,radius);
  }

  void move() {
    y += ay;
    x += ax;

    // SCORE!!! reset ball and increment score;
    if(x>width) {
      p1score++;
      reset();
      
    } else if(x<0) {
      p2score++;
      reset();
    }
    // bounce off top or bottom
    if(y>=(height-(radius/2)) || (y<=(radius/2))) {
      ay=-ay;
    }
  }

  // reset speed and position
  void reset() {
    if((p1score==10)||(p2score==10)) {
      speed=0;
    } else {
      speed=3;
    }
    ax=speed;
    ay=speed;
    y=height/2;
    x=width/2;
  }

  void collide() {
    ax = -ax;
    if (ax<0) {
      ax-=.3;
    } else {
      ax+=.3;
    }
    if (ay<0) {
      ay-=.3;
    } else {
      ay+=.3;
    }
  }
}

/* Paddle Class*/
class Paddle {
  int x, y1, y2, paddleWidth;
  boolean active;
  Paddle(int x, int y1, int y2, int paddleWidth) {
    this.x=x;
    this.y1=y1;
    this.y2=y2;
    this.paddleWidth = paddleWidth;
  }

  void display() {
    stroke(255);
    strokeWeight(paddleWidth);
    line(x,y1,x,y2);
  }
  
  // move the paddle if it's active.
  void move() {
    if(keyPressed) {
      switch(keyCode) {
        case UP:
        if (active) {
          if(y2>0) {
            y1-=3;
            y2-=3;
          }
          
        }
          break;
        case DOWN:
        if(active){
          if(y1<height) {
            y1+=3;
            y2+=3;
          }
        }
          break;
      }   
    }
  }

  void setActive(){
    active = true;
  }
  void setInactive() {
    active = false;
  }
}