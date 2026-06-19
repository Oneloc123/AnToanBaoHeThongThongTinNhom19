package code.salecar.controller.tool;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet(name = "DownloadSigningToolServlet", value = "/download-signing-tool")
public class DownloadSigningToolServlet extends HttpServlet {

    private static final String FILE_NAME = "MyApp-portable.zip";
    private static final int BUFFER_SIZE = 8192;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        URL resourceUrl = getClass().getClassLoader().getResource(FILE_NAME);

        if (resourceUrl == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "File not found: " + FILE_NAME);
            return;
        }

        response.setContentType("application/zip");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"" + FILE_NAME + "\"");

        if ("file".equals(resourceUrl.getProtocol())) {
            try {
                Path filePath = Path.of(resourceUrl.toURI());
                response.setContentLengthLong(Files.size(filePath));
            } catch (Exception ignored) {

            }
        }

        try (InputStream in = getClass().getClassLoader().getResourceAsStream(FILE_NAME);
             OutputStream out = response.getOutputStream()) {

            if (in == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "File not found: " + FILE_NAME);
                return;
            }

            byte[] buffer = new byte[BUFFER_SIZE];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        }
    }
}
