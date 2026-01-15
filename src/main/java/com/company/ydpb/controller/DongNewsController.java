package com.company.ydpb.controller;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.PageDto;
import com.company.ydpb.service.DongNewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/news/*")
public class DongNewsController {
    @Autowired
    private DongNewsService service;

    @GetMapping("/dongnews")
    public String dongNews(@ModelAttribute("cri")Criteria cri, Model model) {
        model.addAttribute("list", service.getList(cri));
        model.addAttribute("pageMaker", new PageDto(cri, service.getTotalCount(cri)));
        return "news/dong_news_list";
    }

    @GetMapping("/dongnewsview")
    public String dongNewsView() {
        return "news/dong_news_view";
    }
}
