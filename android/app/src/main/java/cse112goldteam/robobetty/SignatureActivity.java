package cse112goldteam.robobetty;

import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;


public class SignatureActivity extends ActionBarActivity implements View.OnClickListener{

    private ImageView view;
    private AnimationDrawable frameAnimation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signature);

        this.findViewById(android.R.id.content).setBackgroundResource(Business.background);
        findViewById(R.id.buttonDoneSignActivity).setOnClickListener(this);
        findViewById(R.id.buttonPrev).setOnClickListener(this);
        findViewById(R.id.buttonStartOverOnSignature).setOnClickListener(this);
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
            case R.id.buttonDoneSignActivity:
                Intent gotoDoneActivity = new Intent(this, DoneActivity.class);
                startActivity(gotoDoneActivity);
                overridePendingTransition  (R.anim.right_slide_in, R.anim.right_slide_out);
                break;
            case R.id.buttonPrev:
                this.onBackPressed();
                break;
            case R.id.buttonStartOverOnSignature:
                Intent gotoWelcomeActivity = new Intent(this, WelcomeActivity.class);
                startActivity(gotoWelcomeActivity);
                this.finish();
                break;
        }
    }

    @Override
    public void onBackPressed()
    {
        this.finish();
        overridePendingTransition  (R.anim.left_slide_in, R.anim.left_slide_out);
    }
}
