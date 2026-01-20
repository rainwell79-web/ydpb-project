package com.company.ydpb.mapper;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.domain.GalleryVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface GalleryMapper {
    int getTotalCount(Criteria cri);
    List<GalleryVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    void updateCount(Long bno);
    GalleryVo get(Long bno);
    int insert(GalleryVo vo);
    int update(GalleryVo vo);
    int delete(Long bno);
}
