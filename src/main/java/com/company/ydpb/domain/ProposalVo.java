package com.company.ydpb.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class ProposalVo extends BoardVo {
    private String problem;
    private String effect;
    private String plPublic;
    private String status;
    private String opinion;
    private String memId;
}
