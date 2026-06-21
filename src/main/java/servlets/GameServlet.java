package servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet("/GameServlet")
public class GameServlet extends HttpServlet {
    private static final List<ScoreRecord> scores = Collections.synchronizedList(new ArrayList<>());

    static {
        // Pre-populate with some initial dummy scores to show design excellence on first load
        scores.add(new ScoreRecord("Neo", "Neon Shadow", "Glitch Warden", "Virtual Grid", 450));
        scores.add(new ScoreRecord("Alice", "Cyber Punk", "Data Hound", "Cyber Highway", 320));
        scores.add(new ScoreRecord("Bob", "Pixel Knight", "Sentient Firewall", "Deep Web Abyss", 180));
    }

    public static List<ScoreRecord> getScores() {
        List<ScoreRecord> sortedScores = new ArrayList<>(scores);
        Collections.sort(sortedScores);
        return sortedScores;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("reset".equalsIgnoreCase(action)) {
            // Optional reset score action
            scores.clear();
            response.sendRedirect("GameServlet?action=setup");
            return;
        }
        
        if ("setup".equalsIgnoreCase(action)) {
            // Put scores list in request attribute (redundancy to direct access)
            request.setAttribute("leaderboard", getScores());
            request.getRequestDispatcher("setup.jsp").forward(request, response);
        } else {
            // Default to main menu selection screen
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("start".equalsIgnoreCase(action)) {
            String runnerSkin = request.getParameter("runnerSkin");
            String chaserSkin = request.getParameter("chaserSkin");
            String mapTheme = request.getParameter("mapTheme");
            String playerName = request.getParameter("playerName");

            if (runnerSkin == null || runnerSkin.isEmpty()) runnerSkin = "Cyber Punk";
            if (chaserSkin == null || chaserSkin.isEmpty()) chaserSkin = "Glitch Warden";
            if (mapTheme == null || mapTheme.isEmpty()) mapTheme = "Virtual Grid";
            if (playerName == null || playerName.trim().isEmpty()) playerName = "Player";

            session.setAttribute("runnerSkin", runnerSkin);
            session.setAttribute("chaserSkin", chaserSkin);
            session.setAttribute("mapTheme", mapTheme);
            session.setAttribute("playerName", playerName);

            response.sendRedirect("game.jsp");
        } else if ("submitScore".equalsIgnoreCase(action)) {
            String playerName = request.getParameter("playerName");
            if (playerName == null || playerName.trim().isEmpty()) {
                playerName = (String) session.getAttribute("playerName");
            }
            if (playerName == null || playerName.trim().isEmpty()) {
                playerName = "Anonymous";
            }

            int score = 0;
            try {
                String scoreStr = request.getParameter("score");
                if (scoreStr != null) {
                    score = Integer.parseInt(scoreStr);
                }
            } catch (NumberFormatException e) {
                // Ignore and keep 0
            }

            String runnerSkin = (String) session.getAttribute("runnerSkin");
            String chaserSkin = (String) session.getAttribute("chaserSkin");
            String mapTheme = (String) session.getAttribute("mapTheme");

            if (runnerSkin == null) runnerSkin = "Cyber Punk";
            if (chaserSkin == null) chaserSkin = "Glitch Warden";
            if (mapTheme == null) mapTheme = "Virtual Grid";

            scores.add(new ScoreRecord(playerName, runnerSkin, chaserSkin, mapTheme, score));

            // Post-Redirect-Get pattern to avoid resubmission, redirect to setup page to see the leaderboard
            response.sendRedirect("GameServlet?action=setup");
        } else {
            response.sendRedirect("GameServlet");
        }
    }
}
