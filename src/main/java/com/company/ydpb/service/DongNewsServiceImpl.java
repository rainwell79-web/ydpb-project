package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.DongNewsVo;
import com.company.ydpb.mapper.DongNewsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DongNewsServiceImpl implements DongNewsService {
    @Autowired
    private DongNewsMapper mapper;

    @Override
    public int getTotalCount(Criteria cri) {
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<DongNewsVo> getList(Criteria cri) {
        return mapper.getList(cri);
    }

    @Override
    public void increaseCount(Long dsNo) {
        mapper.updateCount(dsNo);
    }

    @Override
    public DongNewsVo view(Long dsNo) {
        return mapper.get(dsNo);
    }

    @Override
    public int write(DongNewsVo vo) {
        return mapper.insert(vo);
    }

    @Override
    public int edit(DongNewsVo vo) {
        return mapper.update(vo);
    }

    @Override
    public int delete(Long dsNo) {
        return mapper.delete(dsNo);
    }
}
