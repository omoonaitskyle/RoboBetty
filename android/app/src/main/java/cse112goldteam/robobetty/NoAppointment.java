package cse112goldteam.robobetty;


import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.widget.ImageView;

public class NoAppointment extends ActionBarActivity implements View.OnClickListener{

    private ImageView view;
    private AnimationDrawable frameAnimation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_no_appointment);
        this.findViewById(android.R.id.content).setBackgroundResource(Business.background);
        findViewById(R.id.buttonDone2).setOnClickListener(this);
        findViewById(R.id.buttonStartOverOnNoAppt).setOnClickListener(this);

        // Initialize ImageView and set animation on background
        view = (ImageView) findViewById(R.id.imageAnimation);
        view.setBackgroundResource(R.drawable.animation_list);

        // Typecasting the Animation Drawable
        frameAnimation = (AnimationDrawable) view.getBackground();
    }

    // Called when Activity becomes visible or invisible to the user
    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            // Starting the animation when in Focus
            frameAnimation.start();
        } else {
            // Stoping the animation when not in Focus
            frameAnimation.stop();
        }
    }

    @Override
    public void onClick(View v) {
        if(v.getId() == R.id.buttonDone2) {
            Intent gotoWelcomeActivity = new Intent(this, WelcomeActivity.class);
            startActivity(gotoWelcomeActivity);
            this.finish();
        }
        else if (v.getId() == R.id.buttonStartOverOnNoAppt) {
            Intent gotoWelcomeActivity = new Intent(this, WelcomeActivity.class);
            startActivity(gotoWelcomeActivity);
            this.finish();
        }

    }

    @Override
    public void onBackPressed()
    {
        this.finish();
        overridePendingTransition  (R.anim.left_slide_in, R.anim.left_slide_out);
    }
}
