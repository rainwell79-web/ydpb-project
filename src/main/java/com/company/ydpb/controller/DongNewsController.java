package com.company.ydpb.controller;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.PageDto;
import com.company.ydpb.service.DongNewsService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/news/*")
public class DongNewsController {
    @Setter(onMethod_ = @Autowired)
    private DongNewsService service;

    @GetMapping("dongnews")
    public String dongNews(@ModelAttribute("cri") Criteria cri, Model model) {
        model.addAttribute("list", service.getList(cri));
        model.addAttribute("paging", new PageDto(cri, service.getTotalCount(cri)));
        return "news/dong_news_list";
    }

    @GetMapping("dongnewsview")
    public String dongNewsView(@ModelAttribute("dsNo") Long dsNo, @ModelAttribute("cri") Criteria cri, Model model) {
        service.increaseCount(dsNo);
        model.addAttribute("board", service.view(dsNo));
        return "news/dong_news_view";
    }
}
