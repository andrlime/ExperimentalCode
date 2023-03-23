package org.andrewli.gizmos;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.filechooser.FileSystemView;

public class Content extends JPanel implements ActionListener {

    // Define some dictionaries
    static final Map<String, String> divisionMap;
    static final Map<String, String> roundNameMap;
    static {
        Map<String, String> dMap = new HashMap<>();
        dMap.put("MSPF", "Middle School Public Forum");
        dMap.put("OPF", "Open Public Forum");
        dMap.put("NPF", "Novice Public Forum");
        dMap.put("VPF", "Varsity Public Forum");
        divisionMap = Collections.unmodifiableMap(dMap);

        Map<String, String> rMap = new HashMap<>();
        rMap.put("R1", "Round 1");
        rMap.put("R2", "Round 2");
        rMap.put("R3", "Round 3");
        rMap.put("R4", "Round 4");
        rMap.put("R5", "Round 5");
        rMap.put("R6", "Round 6");
        rMap.put("DOF", "Double Octofinals");
        rMap.put("Doubles", "Double Octofinals");
        rMap.put("OF", "Octofinals");
        rMap.put("Octos", "Octofinals");
        rMap.put("QF", "Quarterfinals");
        rMap.put("Quarters", "Quarterfinals");
        rMap.put("SF", "Semifinals");
        rMap.put("Semis", "Semifinals");
        rMap.put("GF", "Grand Finals");
        rMap.put("F", "Grand Finals");
        rMap.put("Finals", "Grand Finals");
        roundNameMap = Collections.unmodifiableMap(rMap);
    }

    JButton uploadButton;

    // Places for those to go
    JLabel divisionLabel;
    JLabel roundNameLabel;
    JPanel table;

    // Colors
    Color DLC_BLUE = new Color(0, 58, 119);
    Color DLC_LIGHT_YELLOW = new Color(254, 228, 153);

    public Content() {
        super();
        setBackground(Color.WHITE);
        setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
        
        // Create panel for instructions and upload
        JPanel instructionPanel = new JPanel();
        instructionPanel.setLayout(new BoxLayout(instructionPanel, BoxLayout.Y_AXIS));
        instructionPanel.setBorder(BorderFactory.createTitledBorder("instructions"));
        instructionPanel.setBackground(Color.WHITE);

        // Add first line of instructions
        JLabel instructions1 = new JLabel("Upload the horizontal schematic for this round here.");
        instructions1.setFont(new Font("Sans Serif", Font.PLAIN, 15));
        instructions1.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        instructionPanel.add(instructions1);

        // Add upload button
        uploadButton = new JButton("Upload schematic");
        uploadButton.addActionListener(this);
        instructionPanel.add(uploadButton);

        // Add second line of instructions
        JLabel instructions2 = new JLabel("Make manual changes. DO NOT forget to check this step.");
        instructions2.setFont(new Font("Sans Serif", Font.PLAIN, 15));
        instructions2.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        instructionPanel.add(instructions2);

        // Add third line of instructions
        JLabel instructions3 = new JLabel("Export as an image, and release to judges and debaters.");
        instructions3.setFont(new Font("Sans Serif", Font.PLAIN, 15));
        instructions3.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        instructionPanel.add(instructions3);

        // Create content panel that displays content
        JPanel contentPanel = new JPanel();
        contentPanel.setLayout(new BoxLayout(contentPanel, BoxLayout.PAGE_AXIS));
        contentPanel.setBackground(Color.WHITE);

        // Label of division (MS / Open / Novice)
        divisionLabel = new JLabel("Please upload a file");
        divisionLabel.setFont(new Font("Serif", Font.BOLD, 36));
        divisionLabel.setForeground(DLC_BLUE);
        divisionLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
        divisionLabel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));

        // Label of round name – 32s? 16? prelim 1?
        roundNameLabel = new JLabel("Please upload a file");
        roundNameLabel.setFont(new Font("Serif", Font.BOLD, 30));
        roundNameLabel.setForeground(DLC_BLUE);
        roundNameLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
        roundNameLabel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        
        // Add both labels
        contentPanel.add(divisionLabel);
        contentPanel.add(roundNameLabel);

        // Add a blank space for the table
        table = new JPanel();
        table.setLayout(new GridLayout(0,5));
        table.setBackground(Color.WHITE);
        table.setBorder(BorderFactory.createEmptyBorder(0, 25, 50, 25));

        // Center both panels
        instructionPanel.setAlignmentX(Component.CENTER_ALIGNMENT);
        contentPanel.setAlignmentX(Component.CENTER_ALIGNMENT);

        // Add some padding to the top
        contentPanel.setBorder(BorderFactory.createEmptyBorder(15, 3, 3, 3));

        // And add them
        add(instructionPanel);
        add(contentPanel);
        add(table);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if(e.getSource() == uploadButton) {
            System.out.println("[LOG]: Attempting upload");

            // Clear the table
            table.removeAll();
            this.updateUI();

            JFileChooser jfc = new JFileChooser();
            jfc.setFileFilter(new FileNameExtensionFilter("csv spreadsheet", "csv"));
            int returnValue = jfc.showOpenDialog(null);
            // int returnValue = jfc.showSaveDialog(null);

            if (returnValue == JFileChooser.APPROVE_OPTION) {
                File selectedFile = jfc.getSelectedFile();
                System.out.println("[LOG]: Uploading " + selectedFile.getAbsolutePath());

                // Parse the contents of this file which should be a csv
                // If you upload the wrong file, that is NOT good.
                try {
                    Scanner myReader = new Scanner(selectedFile);
                    ArrayList<String> csvData = new ArrayList<String>();
                    while (myReader.hasNextLine()) {
                        String data = myReader.nextLine();
                        csvData.add(data);
                    }
                    myReader.close();

                    // Parse the rounds
                    parseRounds(csvData);

                    // Update UI
                    this.updateUI();
                } catch (Exception eek) {
                    System.out.println(eek);
                }
            }
        }
    }

    // Parses rounds from csv sheet and adds them to the UI
    // Also parses the title and round name
    void parseRounds(ArrayList<String> csvData) {

        // Parse the spreadsheet into two array lists of rounds
        ArrayList<Round> A = new ArrayList<Round>();
        ArrayList<Round> B = new ArrayList<Round>();

        // Parse some meta data e.g the division and round name
        String metaDataRaw = csvData.remove(0);
        String[] metaData = metaDataRaw.split(",");
        String divisionNameRaw = metaData[0].substring(1, metaData[0].length() - 1);
        String roundNameRaw = metaData[1].substring(1, metaData[1].length() - 1);
        String divisionName = Content.divisionMap.get(divisionNameRaw);
        String roundName = Content.roundNameMap.get(roundNameRaw);
        divisionLabel.setText(divisionName);
        roundNameLabel.setText(roundName);

        // Is this a non power matched round - this is STRICT
        boolean isNonPowermatched = roundNameRaw == "R1" || roundNameRaw == "R2" || roundNameRaw == "Round 1" || roundNameRaw == "Round 2";
        int adjustment = !isNonPowermatched ? 2 : 0;

        System.out.println("[LOG]: Found round name and division name of " + roundName + ", " + divisionName);
        
        // Parse actual rounds
        for(String rawRound : csvData) {
            String[] dataArray = rawRound.split(",");
            if(dataArray.length == 0) continue;

            // Remove all of the quotes, I do not need them
            for(int i = 0; i < dataArray.length; i ++) {
                dataArray[i] = dataArray[i].substring(1, dataArray[i].length() - 1);
            }

            // Deal with the data now
            if(dataArray[0] == "BYE") {
                String[] judges = { "BYE" };
                A.add(new Round(1, dataArray[1 + adjustment], "", "", judges));
            } else {
                // @TODO: Support elims
                ArrayList<String> judges = new ArrayList<String>();
                for(int k = 9 + adjustment; k < dataArray.length; k += 2) {
                    judges.add(dataArray[k]);
                }

                String[] judgesArray = new String[judges.size()];
                for(int k = 0; k < judgesArray.length; k ++) {
                    judgesArray[k] = judges.get(k);
                }
                
                Round r = new Round(dataArray[0 + adjustment].equals("Flt1") ? 1 : 2, dataArray[1 + adjustment], dataArray[4 + adjustment], dataArray[8 + adjustment], judgesArray);

                if(r.flight == 1) {
                    A.add(r);
                } else {
                    B.add(r);
                }
            }

        }

        TableCell flightALabel = new TableCell("Flight A", Color.WHITE, DLC_BLUE, 24, true);
        table.add(flightALabel);
        table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));
        table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));
        table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));
        table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));

        TableCell flightColumnLabel = new TableCell("Flight", DLC_BLUE, Color.WHITE, 18, true);
        table.add(flightColumnLabel);

        TableCell teamALabel = new TableCell("Team A", DLC_BLUE, Color.WHITE, 18, true);
        table.add(teamALabel);

        TableCell teamBLabel = new TableCell("Team B", DLC_BLUE, Color.WHITE, 18, true);
        table.add(teamBLabel);

        TableCell roomNoLabel = new TableCell("Room Number", DLC_BLUE, Color.WHITE, 18, true);
        table.add(roomNoLabel);

        TableCell judgesLabel = new TableCell("Judges", DLC_BLUE, Color.WHITE, 18, true);
        table.add(judgesLabel);

        for(Round r : A) {
            TableCell flightDataCell = new TableCell("" + r.flight, DLC_LIGHT_YELLOW, Color.BLACK, 15, false);
            TableCell teamADataCell = new TableCell(r.teamA, Color.WHITE, DLC_BLUE, 15, false);
            TableCell teamBDataCell = new TableCell(r.teamB, Color.WHITE, DLC_BLUE, 15, false);
            TableCell meetingDataCell = new TableCell(r.meetingID, Color.WHITE, DLC_BLUE, 15, false);

            String judgesString = "";
            try {
                judgesString = r.judges[0] + " ©";
                for(String j : r.judges) {
                    judgesString += ", " + j;
                }
            } catch(ArrayIndexOutOfBoundsException e) {
                System.out.println("[ERROR]: Array index out of bounds in file Content.java");
            }

            TableCell judgeDataCell = new TableCell(judgesString, Color.WHITE, DLC_BLUE, 15, false);

            table.add(flightDataCell);
            table.add(teamADataCell);
            table.add(teamBDataCell);
            table.add(meetingDataCell);
            table.add(judgeDataCell);
            System.out.println(r.toString());
        }

        if(B.size() > 0) {
            TableCell flightBLabel = new TableCell("Flight B", Color.WHITE, DLC_BLUE, 24, true);
            table.add(flightBLabel);
            table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));
            table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));
            table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));
            table.add(new TableCell("", Color.WHITE, Color.WHITE, 18, true));

            flightColumnLabel = new TableCell("Flight", DLC_BLUE, Color.WHITE, 18, true);
            table.add(flightColumnLabel);

            teamALabel = new TableCell("Team A", DLC_BLUE, Color.WHITE, 18, true);
            table.add(teamALabel);

            teamBLabel = new TableCell("Team B", DLC_BLUE, Color.WHITE, 18, true);
            table.add(teamBLabel);

            roomNoLabel = new TableCell("Room Number", DLC_BLUE, Color.WHITE, 18, true);
            table.add(roomNoLabel);

            judgesLabel = new TableCell("Judges", DLC_BLUE, Color.WHITE, 18, true);
            table.add(judgesLabel);

            // 254, 228, 153

            for(Round r : B) {
                TableCell flightDataCell = new TableCell("" + r.flight, DLC_LIGHT_YELLOW, Color.BLACK, 15, false);
                TableCell teamADataCell = new TableCell(r.teamA, Color.WHITE, DLC_BLUE, 15, false);
                TableCell teamBDataCell = new TableCell(r.teamB, Color.WHITE, DLC_BLUE, 15, false);
                TableCell meetingDataCell = new TableCell(r.meetingID, Color.WHITE, DLC_BLUE, 15, false);

                String judgesString = "";
                try {
                    judgesString = r.judges[0] + " ©";
                    for(String j : r.judges) {
                        judgesString += ", " + j;
                    }
                } catch(ArrayIndexOutOfBoundsException e) {
                    System.out.println("[ERROR]: Array index out of bounds in file Content.java");
                }

                TableCell judgeDataCell = new TableCell(judgesString, Color.WHITE, DLC_BLUE, 15, false);

                table.add(flightDataCell);
                table.add(teamADataCell);
                table.add(teamBDataCell);
                table.add(meetingDataCell);
                table.add(judgeDataCell);
                System.out.println(r.toString());
            }
        }

    }

}
