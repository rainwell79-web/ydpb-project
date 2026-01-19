package com.company.ydpb.controller;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.GuNewsVo;
import com.company.ydpb.domain.PageDto;
import com.company.ydpb.service.GuNewsService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/news/*")
public class GuNewsController {
    @Setter(onMethod_ = @Autowired)
    private GuNewsService service;

    @GetMapping("gunews")
    public String guNews(@ModelAttribute("cri") Criteria cri, Model model) {
        List<GuNewsVo> list = service.getList(cri);
        list.forEach(item -> item.setFiles(service.getFiles(item.getBno())));
        model.addAttribute("list", list);
        model.addAttribute("paging", new PageDto(cri, service.getTotalCount(cri)));
        return "news/gu_news_list";
    }

    @GetMapping("gunewsview")
    public String guNewsView(@ModelAttribute("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
        service.increaseCount(bno);
        GuNewsVo board = service.view(bno);
        board.setFiles(service.getFiles(bno));
        model.addAttribute("board", board);
        return "news/gu_news_view";
    }
}
