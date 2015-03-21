package cse112goldteam.robobetty;

import android.os.AsyncTask;
import android.util.Base64;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * A simple server socket that accepts connection and writes some data on
 * the stream.
 */
public class FindAppointmentAsyncTask extends AsyncTask<Void, Void, String> {

    private static final String TAG = "FileServerAsyncTask";
    private String url = "http://robobetty-dev.herokuapp.com/api/m/appointment";
    private String firstName, lastName, dob;
    private FindAppointmentActivity activity;


    public FindAppointmentAsyncTask(String firstName, String lastName, String dob, FindAppointmentActivity activity) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.dob = dob;
        this.activity = activity;
    }


    @Override
    protected String doInBackground(Void... params) {
        try {

            url += "?fname='" + firstName + "'&lname='" + lastName + "'&dob='" + dob + "'";
            HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();

            c.setRequestMethod("GET");
            String token = Business.API_TOKEN;
            c.setRequestProperty("Authorization", "Token " + token);
            c.setRequestProperty("Content-type", "application/json");

            int responseCode = c.getResponseCode();

            if (responseCode == 200) {
                try {
                    InputStreamReader response = new InputStreamReader(c.getInputStream(), "UTF-8");
                    BufferedReader reader = new BufferedReader(response);
                    String json = "";
                    for (String line; (line = reader.readLine()) != null; ) {
                        json += line;
                    }
                    return json;
                } catch (Exception ex) {
                    Log.e(TAG, "Failed to parse JSON due to: " + ex);
                }
            } else {
                Log.e(TAG, "Server responded with status code: " + c.getResponseCode());
            }
        } catch (Exception ex) {
            Log.e(TAG, "Failed to send HTTP Post request due to: " + ex);
        }

        return "failed";
    }

    @Override
    protected void onPostExecute(String json) {
        if (json == null) {
            return;
        }

        if (json.equals("failed")) {
            activity.appointmentNotFound();
        }

        Log.d("MO", "Post execute " + json);
        try {
            JSONObject info = new JSONObject(json);
            activity.appointmentFound(info);
        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

}


