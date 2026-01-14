package com.company.ydpb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dong/*")
public class DongController {
    @GetMapping("/staff")
    public String staff() {
        return "dong/staff";
    }

    @GetMapping("/status")
    public String status() {
        return "dong/status";
    }

    @GetMapping("/directions")
    public String directions() {
        return "dong/directions";
    }

    @GetMapping("/origin")
    public String origin() {
        return "dong/origin";
    }
}
