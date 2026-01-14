package com.company.ydpb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/news/*")
public class NewsController {
    @GetMapping("/dongnews")
    public String dongNews() {
        return "news/dong_news_list";
    }

    @GetMapping("/dongnewsview")
    public String dongNewsView() {
        return "news/dong_news_view";
    }

    @GetMapping("/gunews")
    public String guNews() {
        return "news/gu_news_list";
    }

    @GetMapping("/gunewsview")
    public String guNewsView() {
        return "news/gu_news_view";
    }

    @GetMapping("/gallery")
    public String gallery() {
        return "news/gallery_list";
    }

    @GetMapping("/galleryview")
    public String galleryView() {
        return "news/gallery_view";
    }
}
