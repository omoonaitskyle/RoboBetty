package cse112goldteam.robobetty;

import android.app.ProgressDialog;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;


public class BusinessLoginActivity extends ActionBarActivity implements View.OnClickListener {

    private EditText editTextEmail, editTextPassword, editTextDeviceName;
    private ProgressDialog dialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_business_login);

        //TODO: add a check here to check if we already logged in. If so, then go to WelcomeActivity

        findViewById(R.id.buttonLogin).setOnClickListener(this);
        editTextEmail = (EditText) findViewById(R.id.editTextEmail);
        editTextPassword = (EditText) findViewById(R.id.editTextPassword);
        editTextDeviceName = (EditText) findViewById(R.id.editTextDeviceName);
    }


    @Override
    public void onClick(View v) {
        if(v.getId() == R.id.buttonLogin){
            String email = editTextEmail.getText().toString();
            String password = editTextPassword.getText().toString();
            String deviceName = editTextDeviceName.getText().toString();

            if(email.isEmpty() || password.isEmpty()){
                Toast.makeText(this, "Fields cannot be empty", Toast.LENGTH_SHORT).show();
                return;
            }

            if(email.equals("goldTeam@test.com")) {
                Business.setBackground(R.drawable.goldbg);
            }
            else {
                Business.setBackground(R.drawable.bg);
            }

            // Start AsyncTask.
            dialog = ProgressDialog.show(this, "", "Loging in...");
            dialog.setCanceledOnTouchOutside(false);
            new BusinessLoginAsyncTask(email, password, this).execute();
        }
    }

    public void successfulLogin(String token){
        dialog.cancel();
        Toast.makeText(this, "Successful Login", Toast.LENGTH_SHORT).show();
        Log.d("MO", token);
        Business.API_TOKEN = token;
        Business.PATIENT_NAME = "";

        Intent gotoWelcomeActivity = new Intent(this, WelcomeActivity.class);
        startActivity(gotoWelcomeActivity);
        overridePendingTransition(R.anim.right_slide_in, R.anim.right_slide_out);
    }

    public void unsuccessfulLogin(){
        dialog.cancel();
        Toast.makeText(this, "Wrong username or password", Toast.LENGTH_SHORT).show();
    }

}
