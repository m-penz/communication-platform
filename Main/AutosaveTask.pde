import java.util.TimerTask;
import java.util.Timer;

public class AutosaveTask extends TimerTask {

  FinishTracker finishTracker;

  public AutosaveTask(FinishTracker finishTracker) {
    this.finishTracker=finishTracker;
  }
  void run() {
    finishTracker.setSessionFinished();
  }
}

