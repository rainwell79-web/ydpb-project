package com.company.ydpb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/proposal/*")
public class ProposalController {
    @GetMapping("/guide")
    public String guide() {
        return "proposal/proposal_guide";
    }

    @GetMapping("/board")
    public String board() {
        return "proposal/proposal_list";
    }

    @GetMapping("/boardview")
    public String boardView() {
        return "proposal/proposal_view";
    }

    @GetMapping("/boarcreate")
    public String boardCreate() {
        return "proposal/proposal_create";
    }

    @GetMapping("/boaredit")
    public String boardEdit() {
        return "proposal/proposal_edit";
    }

}
