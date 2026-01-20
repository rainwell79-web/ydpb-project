package com.company.ydpb.mapper;

import com.company.ydpb.domain.Criteria;
import com.company.ydpb.domain.FileVo;
import com.company.ydpb.domain.ProposalVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ProposalMapper {
    int getTotalCount(Criteria cri);
    List<ProposalVo> getList(Criteria cri);
    List<FileVo> getFiles(Long bno);
    ProposalVo get(Long bno);
    int insert(ProposalVo vo);
    int update(ProposalVo vo);
    int delete(Long bno);
}
