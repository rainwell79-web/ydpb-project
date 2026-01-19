package com.company.ydpb.domain;

import lombok.Data;

@Data
public class PageDto {
    private int startPage;  // 시작번호
    private int endPage;    // 끝번호
    private int realEnd;    // 전체 끝번호
    private int prevPage;   // 이전 10페이지 번호
    private int nextPage;   // 다음 10페이지 번호
    private int startNum;   // 시작 글번호
    private boolean isArrows;   // 페이징 이동 버튼 유무
    private int total;      // 전체 게시글 갯수
    private Criteria cri;   // pageNum(현재 페이지 번호), amount(보여줄 게시글 갯수)

    public PageDto(Criteria cri, int total) {
        this.cri = cri;
        this.total = total;
        // 끝번호(endPage) 계산공식
        this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
        // 시작번호(startPage) 계산공식
        this.startPage = this.endPage - 9;

        // 전체데이터수(total)을 이용해 진짜 끝페이지(realEnd)가 몇번까지인지 계산
        this.realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
        // 진짜 끝페이지(realEnd)가 구해둔 끝번호(endPage)보다 작다면, 끝번호는 작은값이 되어야 함
        if (this.realEnd < this.endPage) {
            this.endPage = this.realEnd;
        }
        this.prevPage = Math.max(this.startPage - 1, 1);
        this.nextPage = Math.min(this.startPage + 10, this.realEnd);
        this.startNum = total - ((cri.getPageNum() - 1) * cri.getAmount());

        // 이전(prev) 계산 = 페이징이 10개 이상이라면 존재
        this.isArrows = this.realEnd > 10;
    }
}
