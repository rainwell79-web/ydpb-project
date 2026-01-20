package com.company.ydpb.controller;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.PageDto;
import com.company.ydpb.domain.ProposalVo;
import com.company.ydpb.service.ProposalService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/proposal/*")
public class ProposalController {
    @Setter(onMethod_ = @Autowired)
    private ProposalService service;

    @GetMapping("/guide")
    public String guide() {
        return "proposal/proposal_guide";
    }

    @GetMapping("/board")
    public String board(@ModelAttribute("cri") Criteria cri, Model model) {
        List<ProposalVo> list = service.getList(cri);
        list.forEach(item -> item.setFiles(service.getFiles(item.getBno())));
        model.addAttribute("list", list);
        model.addAttribute("paging", new PageDto(cri, service.getTotalCount(cri)));
        return "proposal/proposal_list";
    }

    @GetMapping("/boardview")
    public String boardView(@ModelAttribute("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
        ProposalVo board = service.view(bno);
        board.setFiles(service.getFiles(bno));
        model.addAttribute("board", board);
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
