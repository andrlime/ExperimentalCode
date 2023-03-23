package org.andrewli.gizmos;

import java.awt.BorderLayout;
import java.awt.Color;

import javax.swing.*;

public class Assistant extends JPanel {

    public Assistant() {
        super(new BorderLayout());
        setBackground(Color.WHITE);

        // Add header
        add(new Header(), BorderLayout.PAGE_START);

        // Add content
        add(new Content(), BorderLayout.CENTER);
    }

    public static void main(String[] args) {
        // Initiate the window
        JFrame window = new JFrame("NHSDLC Tabroom Assistant");
        window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        window.setSize(1200, 800);

        // Add the app
        window.add(new Assistant(), BorderLayout.CENTER);

        // Set visibility
        window.setVisible(true);
    }

}
