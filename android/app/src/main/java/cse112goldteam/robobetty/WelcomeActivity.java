package cse112goldteam.robobetty;

import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;


public class WelcomeActivity extends ActionBarActivity implements View.OnClickListener {

    private ImageView view;
    private AnimationDrawable frameAnimation;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);
        this.findViewById(android.R.id.content).setBackgroundResource(Business.background);
        // Set listeners for the buttons.
        findViewById(R.id.buttonCheckIn).setOnClickListener(this);
        findViewById(R.id.buttonNoAppointment).setOnClickListener(this);

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


    /**
     * Call back when user clicks on a button.
     *
     * implements: OnClickListener
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()){

            case R.id.buttonCheckIn:
                Intent gotoFindAppointmentActivity = new Intent(this, FindAppointmentActivity.class);
                startActivity(gotoFindAppointmentActivity);
                overridePendingTransition(R.anim.right_slide_in, R.anim.right_slide_out);
                break;

            case R.id.buttonNoAppointment:
                Intent gotoNoAppointmentActivity = new Intent(this, NoAppointment.class);
                startActivity(gotoNoAppointmentActivity);
                overridePendingTransition(R.anim.right_slide_in, R.anim.right_slide_out);
                break;
        }
    }

    @Override
    public void onBackPressed() {
        this.finish();
        Intent gotoBusinessLoginActivity = new Intent(this, BusinessLoginActivity.class);
        startActivity(gotoBusinessLoginActivity);
        overridePendingTransition(R.anim.left_slide_in, R.anim.left_slide_out);

    }

}
