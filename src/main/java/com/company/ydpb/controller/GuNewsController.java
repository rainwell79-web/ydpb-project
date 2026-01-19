package com.company.ydpb.controller;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.PageDto;
import com.company.ydpb.service.GuNewsService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/news/*")
public class GuNewsController {
    @Setter(onMethod_ = @Autowired)
    private GuNewsService service;

    @GetMapping("gunews")
    public String guNews(@ModelAttribute("cri") Criteria cri, Model model) {
        model.addAttribute("list", service.getList(cri));
        model.addAttribute("paging", new PageDto(cri, service.getTotalCount(cri)));
        return "news/gu_news_list";
    }

    @GetMapping("gunewsview")
    public String guNewsView(@ModelAttribute("dsNo") Long dsNo, @ModelAttribute("cri") Criteria cri, Model model) {
        service.increaseCount(dsNo);
        model.addAttribute("board", service.view(dsNo));
        return "news/gu_news_view";
    }
}
