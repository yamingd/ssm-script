package com.inno.xyb;

import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Created by dengyaming on 8/30/16.
 */
public class Main {

    public static void main(String[] args) throws Exception{
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring/root-context.xml");
        context.start();
    }

}
