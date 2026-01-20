package com.company.ydpb.controller;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.GalleryVo;
import com.company.ydpb.domain.PageDto;
import com.company.ydpb.service.GalleryService;
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
public class GalleryController {
    @Setter(onMethod_ = @Autowired)
    private GalleryService service;

    @GetMapping("gallery")
    public String gallery(@ModelAttribute("cri") Criteria cri, Model model) {
        cri.setAmount(12);
        List<GalleryVo> list = service.getList(cri);
        list.forEach(item -> item.setFiles(service.getFiles(item.getBno())));
        model.addAttribute("list", list);
        model.addAttribute("paging", new PageDto(cri, service.getTotalCount(cri)));
        return "news/gallery_list";
    }

    @GetMapping("galleryview")
    public String galleryView(@ModelAttribute("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
        service.increaseCount(bno);
        GalleryVo board = service.view(bno);
        board.setFiles(service.getFiles(bno));
        model.addAttribute("board", board);
        return "news/gallery_view";
    }
}
