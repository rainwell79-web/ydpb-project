package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.domain.GalleryVo;

import java.util.List;

public interface GalleryService {
    int getTotalCount(Criteria cri);
    List<GalleryVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    void increaseCount(Long bno);
    GalleryVo view(Long bno);
    int write(GalleryVo vo);
    int edit(GalleryVo vo);
    int delete(Long bno);
}
