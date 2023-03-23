package org.andrewli.gizmos;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class Header extends JPanel {

    public Header() {
        super(new FlowLayout(FlowLayout.LEADING));
        setBackground(Color.WHITE);

        try {
            BufferedImage nhsdlc_logo = ImageIO.read(new File("assets/icon.png"));
            JLabel logo_label = new JLabel(new ImageIcon(nhsdlc_logo));
            add(logo_label);
        } catch (Exception e) {
            System.out.println(e);
        }

        JLabel title = new JLabel("NHSDLC Tabroom Assistant");
        title.setFont(new Font("Sans Serif", Font.BOLD, 24));
        title.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
        add(title);
    }

}
