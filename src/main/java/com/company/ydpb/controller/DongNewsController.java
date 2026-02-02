package com.company.ydpb.controller;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.DongNewsVo;
import com.company.ydpb.domain.PageDto;
import com.company.ydpb.service.DongNewsService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/news/*")
public class DongNewsController {
    @Setter(onMethod_ = @Autowired)
    private DongNewsService service;

    @GetMapping("dongnews")
    public String dongNews(@ModelAttribute("cri") Criteria cri, Model model) {
        List<DongNewsVo> list = service.getList(cri);
        list.forEach(item -> item.setFiles(service.getFiles(item.getBno())));
        model.addAttribute("list", list);
        model.addAttribute("paging", new PageDto(cri, service.getTotalCount(cri)));
        return "news/dong_news_list";
    }

    @GetMapping("dongnewsview")
    public String dongNewsView(@ModelAttribute("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
        service.increaseCount(bno);
        DongNewsVo board = service.view(bno);
        board.setFiles(service.getFiles(bno));
        model.addAttribute("board", board);
        return "news/dong_news_view";
    }

    @GetMapping(value = "period/{startDate}/{endDate}", produces = {MediaType.TEXT_PLAIN_VALUE})
    public ResponseEntity<String> dongNewsPeriod(@PathVariable String startDate, @PathVariable String endDate) {
        return ResponseEntity.ok(String.valueOf(service.getCountPeriod(startDate, endDate)));
    }
}
