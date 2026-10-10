package com.tmdt.untils;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.tmdt.Model.User;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

import java.io.IOException;
public class GoogleUntils {
    public static final String GOOGLE_CLIENT_ID = "918892325001-opqt9q70e7q7n0qstli2a3qqi8kb1rts.apps.googleusercontent.com";
    public static final String GOOGLE_CLIENT_SECRET = "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";
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/TMDT_Nhom_3_2_war/google-login";
    public static final String GOOGLE_LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://openidconnect.googleapis.com/v1/userinfo";

    public static String getToken(String code) throws IOException {

        String response = Request.Post(GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form()
                        .add("client_id", GOOGLE_CLIENT_ID)
                        .add("client_secret", GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", "authorization_code")
                        .build())
                .execute()
                .returnContent()
                .asString();

        JsonObject result =
                new Gson().fromJson(response, JsonObject.class);

        if (result == null || !result.has("access_token")) {
            throw new IOException(
                    "Không lấy được access token từ Google: " + response
            );
        }

        return result.get("access_token").getAsString();
    }

    public static User getUserInfo(String accessToken)
            throws IOException {

        String response = Request.Get(GOOGLE_LINK_GET_USER_INFO)
                .addHeader("Authorization", "Bearer " + accessToken)
                .execute()
                .returnContent()
                .asString();

        JsonObject googleUser =
                new Gson().fromJson(response, JsonObject.class);

        if (googleUser == null || !googleUser.has("email")) {
            throw new IOException(
                    "Google không trả về thông tin email: " + response
            );
        }

        String email =
                googleUser.get("email").getAsString();

        boolean emailVerified =
                googleUser.has("email_verified")
                        && googleUser.get("email_verified").getAsBoolean();

        if (!emailVerified) {
            throw new IOException(
                    "Email Google chưa được xác minh"
            );
        }

        String fullname = email;

        if (googleUser.has("name")
                && !googleUser.get("name").isJsonNull()) {
            fullname = googleUser.get("name").getAsString();
        }

        User user = new User(
                fullname,
                null,
                email,
                null,
                "BUYER",
                true,
                null,
                "GOOGLE"
                ,"ACTIVE"
        );



        return user;
    }
}
