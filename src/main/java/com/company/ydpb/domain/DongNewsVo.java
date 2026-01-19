package com.company.ydpb.domain;

import lombok.Data;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

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

    public List<FileDto> getFiles() {
        List<FileDto> list = new ArrayList<>();
        if(this.dsFiles != null && !this.dsFiles.isEmpty()) {
            for(int i = 0; i < dsFiles.split(",").length; i++) {
                String fileName = dsFiles.split(",")[i];
                String[] fileNameArr = fileName.split("\\.");
                FileDto file = new FileDto();
                file.setName(fileName);
                file.setType(fileNameArr[fileNameArr.length - 1]);
                list.add(file);
            }
        }
        return list;
    }
    public String getFileType() {
        String result = null;
        if(this.dsFiles != null && !this.dsFiles.isEmpty()) {
            result = getFiles().get(0).getType();
        }
        return result;
    }
    public boolean isNew() {
        return Duration.between(this.dsRegdate.toInstant(), Instant.now()).toHours() < 24;
    }
}
