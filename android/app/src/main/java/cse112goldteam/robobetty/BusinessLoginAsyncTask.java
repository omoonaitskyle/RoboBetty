package cse112goldteam.robobetty;

import android.os.AsyncTask;
import android.util.Base64;
import android.util.Log;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * A simple server socket that accepts connection and writes some data on
 * the stream.
 */
public class BusinessLoginAsyncTask extends AsyncTask<Void, Void, String> {

    private static final String TAG = "FileServerAsyncTask";
    private static final String url = "http://robobetty-dev.herokuapp.com/api/auth";
    private String email;
    private String password;
    private BusinessLoginActivity activity;


    public BusinessLoginAsyncTask(String email, String password, BusinessLoginActivity activity) {
        this.email = email;
        this.password = password;
        this.activity = activity;
    }


    @Override
    protected String doInBackground(Void... params) {
        try {

            HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();


            //Create an HTTP client
            String info = email + ":" + password;

            JSONObject object = new JSONObject();
            try {

                object.put("name", "Frodo");

            } catch (Exception ex) {

            }

            String message = object.toString();


            c.setRequestMethod("POST");
            c.setRequestProperty("Authorization", "Basic " + Base64.encodeToString(info.getBytes(), Base64.NO_WRAP));
            c.setRequestProperty("Content-type", "application/json");
            DataOutputStream printout = new DataOutputStream(c.getOutputStream());
            byte[] blah = message.getBytes("UTF-8");
            printout.write(blah);
            printout.flush();
            printout.close();

            int responseCode = c.getResponseCode();

            if(responseCode == 401){
                return "unsuccessfulLogin";
            }

            if (responseCode == 200) {
                try {
                    InputStreamReader response = new InputStreamReader(c.getInputStream(),"UTF-8");
                    BufferedReader reader = new BufferedReader(response);
                    String token = "";
                    for (String line; (line = reader.readLine()) != null; ) {
                        token += line;
                    }
                    return token;
                } catch (Exception ex) {
                    Log.e(TAG, "Failed to parse JSON due to: " + ex);
                }
            } else {
                Log.e(TAG, "Server responded with status code: " + c.getResponseCode());
            }
        } catch (Exception ex) {
            Log.e(TAG, "Failed to send HTTP Post request due to: " + ex);
        }

        return "unsuccessfulLogin";
    }

    @Override
    protected void onPostExecute(String token) {
        if (token == null) {
            return;
        }

        if(token.equals("unsuccessfulLogin")){
            activity.unsuccessfulLogin();
        }

        Log.d("MO", "Post execute " + token);
        try {
            JSONObject json = new JSONObject(token);
            activity.successfulLogin(json.getString("api_token"));
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

}


