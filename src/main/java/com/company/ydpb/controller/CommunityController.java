package com.company.ydpb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/community/*")
public class CommunityController {
    @GetMapping("/guide")
    public String guide() {
        return "community/community_guide";
    }

    @GetMapping("/board")
    public String list() {
        return "community/community_list";
    }

}
