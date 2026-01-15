package com.company.ydpb.domain;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class DongNewsVo {
    private long dsNo;
    private String dsTitle;
    private String dsContent;
    private String dsDepart;
    private String dsTel;
    private String dsHit;
    private String dsFiles;
    private Timestamp dsRegdate;
}
