package cse112goldteam.robobetty;

import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class FoundActivity extends ActionBarActivity implements View.OnClickListener {

    private ImageView view;
    private AnimationDrawable frameAnimation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_found_activity);
        String fname = "", lname = "", dob = "", email = "";

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            fname = extras.getString("FNAME");
            lname = extras.getString("LNAME");
            dob = extras.getString("DOB");
            email = extras.getString("EMAIL");
        }

        ((TextView) findViewById(R.id.textViewName)).setText("Hi, " + fname);
        ((TextView) findViewById(R.id.textViewFullName)).setText(fname + " " + lname);
        ((TextView) findViewById(R.id.textViewDOB)).setText(dob);
        ((TextView) findViewById(R.id.textViewEmail)).setText(email);

        this.findViewById(android.R.id.content).setBackgroundResource(Business.background);
        findViewById(R.id.buttonNext).setOnClickListener(this);
        findViewById(R.id.buttonNotYou).setOnClickListener(this);
        findViewById(R.id.buttonStartOverOnFoundAppt).setOnClickListener(this);

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
        switch (v.getId()){
            case R.id.buttonNext:
                Intent gotoCustomFormActivity = new Intent(this, CustomFormActivity.class);
                startActivity(gotoCustomFormActivity);
                overridePendingTransition  (R.anim.right_slide_in, R.anim.right_slide_out);
                break;

            case R.id.buttonNotYou:
                this.onBackPressed();
                break;
            case R.id.buttonStartOverOnFoundAppt:
                Intent gotoWelcomeActivity = new Intent(this, WelcomeActivity.class);
                startActivity(gotoWelcomeActivity);
                this.finish();
                break;
        }
    }

    public void onBackPressed() {
        this.finish();
        Intent gotoFindAppointmentActivity = new Intent(this, FindAppointmentActivity.class);
        startActivity(gotoFindAppointmentActivity);
        overridePendingTransition(R.anim.left_slide_in, R.anim.left_slide_out);
    }

}
