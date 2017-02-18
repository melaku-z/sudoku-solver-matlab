function matrixnot=humansudoku(given)%given=[a1 b1 c1;a2 b2 c2;a3 b3 c3; . . .],a-raw,b-col,c-value
matrixnot=zeros(9,9,8);%to check an unsolvable, i.e, matrixnot value 9, create zeros(9,9,9) if all 9 different error
givens=size(given);givens=givens(1);
for giv=1:givens
    raw=given(giv,1);
    col=given(giv,2);
    val=given(giv,3);
    ind1=1;
    for ind=1:9
        if ind~=val
            matrixnot(raw,col,ind1)=ind;
            ind1=ind1+1;
        end
    end
    if raw==1||raw==2||raw==3
        cornerraw=1;
    elseif raw==4||raw==5||raw==6
        cornerraw=4;
    elseif raw==7||raw==8||raw==9
        cornerraw=7;
    end
    if col==1||col==2||col==3
        cornercol=1;
    elseif col==4||col==5||col==6
        cornercol=4;
    elseif col==7||col==8||col==9
        cornercol=7;
    end
    for coll=1:9
        if coll==col
            continue
        end
        n=8;
        matrixnot=sortmatrixnot(matrixnot);
        while n>0 && ~matrixnot(raw,coll,n)
            n=n-1;
        end
        if n==8
            continue
        end
        matrixnot(raw,coll,n+1)=val;
    end
    for roww=1:9
        if roww==raw
            continue
        end
        n=8;
        matrixnot=sortmatrixnot(matrixnot);
        while n>0 && ~matrixnot(roww,col,n)
            n=n-1;
        end
        if n==8
            continue
        end
        matrixnot(roww,col,n+1)=val;
    end
    for roww=cornerraw:cornerraw+2
        for coll=cornercol:cornercol+2
            if coll==col&&roww==raw
                continue
            end
            n=8;
            matrixnot=sortmatrixnot(matrixnot);
            while n>0 && ~matrixnot(roww,coll,n)
                n=n-1;
            end
            if n==8
                continue
            end
            matrixnot(roww,coll,n+1)=val;
        end
    end
    matrixnot=sortmatrixnot(matrixnot);
end
end
function matrixnot=sortmatrixnot(mn)
matrixnot=mn;
for roww=1:9
    for coll=1:9
        intermediate=unique(matrixnot(roww,coll,:));inter=length(intermediate);
        for ww=1:inter
            matrixnot(roww,coll,ww)=intermediate(ww);
        end
        for ww=inter+1:8
            matrixnot(roww,coll,ww)=0;
        end
    end
end
matrixnot=sort(matrixnot,3,'descend');
end