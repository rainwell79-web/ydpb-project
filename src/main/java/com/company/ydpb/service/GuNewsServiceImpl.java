package com.company.ydpb.service;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.GuNewsVo;
import com.company.ydpb.mapper.GuNewsMapper;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GuNewsServiceImpl implements GuNewsService {
    @Setter(onMethod_ = @Autowired)
    private GuNewsMapper mapper;

    @Override
    public int getTotalCount(Criteria cri) {
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<GuNewsVo> getList(Criteria cri) {
        return mapper.getList(cri);
    }

    @Override
    public void increaseCount(Long dsNo) {
        mapper.updateCount(dsNo);
    }

    @Override
    public GuNewsVo view(Long dsNo) {
        return mapper.get(dsNo);
    }

    @Override
    public int write(GuNewsVo vo) {
        return mapper.insert(vo);
    }

    @Override
    public int edit(GuNewsVo vo) {
        return mapper.update(vo);
    }

    @Override
    public int delete(Long dsNo) {
        return mapper.delete(dsNo);
    }
}
