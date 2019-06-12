class Robot extends Enemy{
	// Requirement #5: Complete Dinosaur Class

	final int PLAYER_DETECT_RANGE_ROW = 2;
	final int LASER_COOLDOWN = 180;
	final int HAND_OFFSET_Y = 37;
	final int HAND_OFFSET_X_FORWARD = 64;
	final int HAND_OFFSET_X_BACKWARD = 16;
  
  int lasercooldown = LASER_COOLDOWN;
  Laser laser;
  float speed = 2f;
  final float TRIGGERED_SPEED_MULTIPLIER = 5;
  
  void display(){
    int direction = (speed > 0) ? RIGHT : LEFT;
    
    pushMatrix();
    translate(x, y);
    if (direction == RIGHT) {
      scale(1, 1);
      image(robot, 0, 0, w, h); 
    } else {
      scale(-1, 1);
      image(robot, -w, 0, w, h); 
    }
    popMatrix();
    
    laser.display();
  }
  
  Robot(float x, float y){
    super(x, y);
    laser = new Laser();
  }
  
  void checkCollision(Player player){
    if(isHit(x, y, w, h, player.x, player.y, player.w, player.h)) {player.hurt();}
    
    laser.checkCollision(player);
  }
  
  void update(){
    float currentSpeed = speed;
    boolean checkX = (speed>=0 && player.x+(w/2) > x+HAND_OFFSET_X_FORWARD) || (speed<=0 && player.x+(w/2) < x+HAND_OFFSET_X_BACKWARD);
    boolean checkY = (abs(y/SOIL_SIZE - player.row)) <= PLAYER_DETECT_RANGE_ROW;
    
    if(checkX == false || checkY == false)
    {
      x += currentSpeed;
      if(x < 0|| x > width-w) speed *= -1; 
    }
    else
    { 
      if(lasercooldown == LASER_COOLDOWN)
      {
        if(currentSpeed>0)
        {
          laser.fire(x+HAND_OFFSET_X_FORWARD,y+HAND_OFFSET_Y,player.x+w/2,player.y+h/2);
        }
        if(currentSpeed<0)
        {
          laser.fire(x+HAND_OFFSET_X_BACKWARD,y+HAND_OFFSET_Y,player.x+w/2,player.y+h/2);
        }
        currentSpeed = 0;
      }
      lasercooldown --;
      if(lasercooldown <= 0) lasercooldown = LASER_COOLDOWN;
      currentSpeed = speed;
    }
    if(player.x == 4 * SOIL_SIZE && player.y == - SOIL_SIZE) lasercooldown = LASER_COOLDOWN;
    laser.update();
    
  }
  
  }
  

	// HINT: Player Detection in update()
	/*

	boolean checkX = ( Is facing forward AND player's center point is in front of my hand point )
					OR ( Is facing backward AND player's center point (x + w/2) is in front of my hand point )

	boolean checkY = player is less than (or equal to) 2 rows higher or lower than me

	if(checkX AND checkY){
		Is laser's cooldown ready?
			True  > Fire laser from my hand!
			False > Don't do anything
	}else{
		Keep moving!
	}

	*/
