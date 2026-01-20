package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.domain.GalleryVo;
import com.company.ydpb.mapper.GalleryMapper;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GalleryServiceImpl implements GalleryService {
    @Setter(onMethod_ = @Autowired)
    private GalleryMapper mapper;

    @Override
    public int getTotalCount(Criteria cri) {
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<GalleryVo> getList(Criteria cri) {
        return mapper.getList(cri);
    }

    @Override
    public List<FileVo> getFiles(Long bno) {
        return mapper.getFiles(bno);
    }

    @Override
    public void increaseCount(Long bno) {
        mapper.updateCount(bno);
    }

    @Override
    public GalleryVo view(Long bno) {
        return mapper.get(bno);
    }

    @Override
    public int write(GalleryVo vo) {
        return mapper.insert(vo);
    }

    @Override
    public int edit(GalleryVo vo) {
        return mapper.update(vo);
    }

    @Override
    public int delete(Long bno) {
        return mapper.delete(bno);
    }
}
