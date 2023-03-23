package org.andrewli.gizmos;

public class Round {
    int flight;
    String teamA;
    String teamB;
    String meetingID;
    String[] judges;

    public Round(int flight, String teamA, String teamB, String meetingID, String[] judges) {
        this.flight = flight;
        this.teamA = teamA;
        this.teamB = teamB;
        this.meetingID = meetingID;
        this.judges = judges;
    }

    public String toString() {
        return this.flight + " " + this.teamA + " vs " + this.teamB + " @" + this.meetingID + " judged by " + this.judges.toString();
    }
}
