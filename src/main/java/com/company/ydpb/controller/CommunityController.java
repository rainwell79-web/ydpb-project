package com.company.ydpb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommunityController {
    @GetMapping("/community/guide")
    public String guide() {
        return "community/community_guide.html";
    }

}
