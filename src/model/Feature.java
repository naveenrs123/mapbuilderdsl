package model;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;

public class Feature implements Cloneable {

    private String id;
    private String iconName;
    private BufferedImage icon;
    private Point location;
    private Integer size = 24;

    public Feature(String id, String iconName, Integer size) {
        this.size = size;
        this.iconName = iconName;
        this.id = id;
    }

    public String getId() {
        return id;
    }


    public BufferedImage getIcon() {
        if (icon == null) {
            return fetchIcon(iconName);
        } else {
            return icon;
        }
    }

    public Point getLocation() {
        return location;
    }


    public Integer getSize() {
        return size;
    }

    public void setLocation(Point location) {
        this.location = location;
    }

    public void setSize(Integer size) {
        this.size = size;
    }


    public Object clone() {
        try {
            return super.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
            return null;
        }
    }

    private BufferedImage fetchIcon(String iconName) {
        try {
            InputStream inputStream = getClass().getClassLoader().getResourceAsStream(String.format( "%s_%dpx.png", iconName, 32));
            return ImageIO.read(inputStream);
        } catch (IOException e) {
            return null;
        }
    }
}
