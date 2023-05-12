report 50010 "Delete Item Filter"
{
    ProcessingOnly = true;
    dataset
    {

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(opgion)
                {
                    field(Detyp; Detyp)
                    {
                        ApplicationArea = all;
                        Caption = 'Type IMP';
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    begin
        deleteItemS();
    end;

    var
        Detyp: Text[20];

    procedure deleteItemS()
    var
        ItemS: Record Item;
    begin
        if Detyp <> '' then begin
            ItemS.Reset;
            ItemS.SetRange(TypeIM, Detyp);
            if ItemS.Find('-') then begin
                repeat
                    ItemS.Delete(true);
                until ItemS.Next = 0;
            end;
        end;
    end;
}