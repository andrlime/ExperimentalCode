package org.andrewli.gizmos;

import java.awt.Color;
import java.awt.Font;

import javax.swing.BorderFactory;
import javax.swing.JLabel;

public class TableCell extends JLabel {
    String label;
    Color bg;
    Color fg;

    public TableCell(String label, Color background, Color foreground, int fontSize, boolean bold) {
        super(label);
        this.label = label;
        this.bg = background;
        this.fg = foreground;

        setFont(new Font("Sans Serif", bold ? Font.BOLD : Font.PLAIN, fontSize));
        setOpaque(true);
        setBackground(background);
        setForeground(foreground);
        setBorder(BorderFactory.createLineBorder(background, 8));
    }

    void setLabel(String l) {
        this.label = l;
        this.updateUI();
    }
}
