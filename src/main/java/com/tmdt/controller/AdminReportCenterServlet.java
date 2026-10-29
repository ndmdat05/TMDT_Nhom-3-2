
package com.tmdt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(
        name = "AdminReportCenterServlet",
        urlPatterns = {"/admin/report-center"}
)
public class AdminReportCenterServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage?tab=report-center"
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                        + "/admin/manage?tab=report-center"
        );
    }
}
