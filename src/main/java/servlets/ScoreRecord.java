package servlets;

import java.util.Date;

public class ScoreRecord implements Comparable<ScoreRecord> {
    private String playerName;
    private String runnerSkin;
    private String chaserSkin;
    private String mapTheme;
    private int score;
    private Date timestamp;

    public ScoreRecord() {
        this.timestamp = new Date();
    }

    public ScoreRecord(String playerName, String runnerSkin, String chaserSkin, String mapTheme, int score) {
        this.playerName = playerName;
        this.runnerSkin = runnerSkin;
        this.chaserSkin = chaserSkin;
        this.mapTheme = mapTheme;
        this.score = score;
        this.timestamp = new Date();
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public String getRunnerSkin() {
        return runnerSkin;
    }

    public void setRunnerSkin(String runnerSkin) {
        this.runnerSkin = runnerSkin;
    }

    public String getChaserSkin() {
        return chaserSkin;
    }

    public void setChaserSkin(String chaserSkin) {
        this.chaserSkin = chaserSkin;
    }

    public String getMapTheme() {
        return mapTheme;
    }

    public void setMapTheme(String mapTheme) {
        this.mapTheme = mapTheme;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public int compareTo(ScoreRecord other) {
        // Sort descending by score
        return Integer.compare(other.getScore(), this.getScore());
    }
}
