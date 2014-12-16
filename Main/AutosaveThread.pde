import java.util.Timer;

class AutosaveThread extends Thread{
    FinishTracker finTracker;
    Timer timer;
    AutosaveTask autosaveTask;
    long delay,interval;
    
    public AutosaveThread(FinishTracker finTracker){
      this.finTracker=finTracker;
      autosaveTask=new AutosaveTask(finTracker);
      
      delay= 1;
      //interval of 20 minutes
      interval=20;
    }
    
    public void run(){
      timer = new Timer(true);
      timer.scheduleAtFixedRate(autosaveTask,delay*60*1000,interval*60*1000);
    }    
}
