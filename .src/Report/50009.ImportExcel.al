report 50009 "Import Kanban Ex"
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
                group(option)
                {
                    field(PDSelect; PDSelect)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            // if PDSelect<>'' then

            IF CloseAction = ACTION::OK THEN BEGIN
                ServerFileName := FileMgt.UploadFile(Text006, ExcelExtensionTok);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);
                //SheetName:='sheet1';

                SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                IF SheetName = '' THEN
                    EXIT(FALSE);

            END;
        end;

    }
    var
        utility: Codeunit Utility;
        ExcelBuf: Record "Excel Buffer";
        ServerFileName: Text;
        SheetName: Text;
        TotalRows: Integer;
        CountRows: Integer;
        TotalColumns: Integer;
        FileMgt: Codeunit "File Management";
        X: Integer;
        TRow: Integer;
        Text006: Label 'Import Excel File';
        ExcelExtensionTok: Label '.xlsx';
        KanbanImp: Record "Import Kanban";
        PDSelect: Enum "Prod. Process"; //Option PD1,PD2,PD3,PD4,PD5,SGA,OTH;

    trigger OnPreReport()
    begin
        ExcelBuf.DELETEALL;
        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBook(ServerFileName, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;
        //TotalRows
        TRow := 0;
        // TSaleOrder.RESET;
        // IF TSaleOrder.FINDLAST THEN BEGIN
        //      TRow := TSaleOrder.EntryNo; END;
        KanbanImp.Reset();
        KanbanImp.DeleteAll();
        //Message(format(TotalRows));
        FOR X := 1 TO TotalRows DO
            InsertData(X);

        ExcelBuf.DELETEALL;
    end;


    procedure InsertData(RowNo: Integer)
    var
        Qty: Integer;
        run: Integer;
        Rows: Integer;
        KanbanCheck: Record "Import Kanban";
        KanbanNo: Code[30];
        UnitPrice: Decimal;
    begin
        KanbanNo := format(GetValueAtCell(RowNo, 1));
        if RowNo = 1 then
            exit;
        if KanbanNo = 'NO KANBAN' then
            exit;
        KanbanCheck.Reset();
        KanbanCheck.SetRange("Kanban No.", KanbanNo);
        if NOT KanbanCheck.Find('-') then begin
            Qty := 1;
            run := 1;
            UnitPrice := 0;

            if Evaluate(Qty, Format(GetValueAtCell(RowNo, 12))) then;
            // Evaluate(Qty, Format(GetValueAtCell(RowNo, 12)));
            if Evaluate(run, Format(GetValueAtCell(RowNo, 13))) then;
            // Evaluate(run, Format(GetValueAtCell(RowNo, 13)));
            if Evaluate(UnitPrice, Format(GetValueAtCell(RowNo, 17))) then;
            //   Evaluate(UnitPrice, Format(GetValueAtCell(RowNo, 17)));


            KanbanImp.Reset();
            KanbanImp.Init();
            KanbanImp."Kanban No." := KanbanNo;
            KanbanImp."Master No." := Format(GetValueAtCell(RowNo, 2));
            KanbanImp.Classification := Format(GetValueAtCell(RowNo, 3));
            KanbanImp.Address := GetValueAtCell(RowNo, 4);
            KanbanImp.Location := Format(GetValueAtCell(RowNo, 5));
            KanbanImp.Process := GetValueAtCell(RowNo, 6);
            KanbanImp."Tool#" := GetValueAtCell(RowNo, 7);
            KanbanImp.Description := GetValueAtCell(RowNo, 8);
            KanbanImp.Model := GetValueAtCell(RowNo, 9);
            KanbanImp.Maker := GetValueAtCell(RowNo, 10);
            KanbanImp.Note := GetValueAtCell(RowNo, 11);
            KanbanImp.Qty := Qty;//12
            KanbanImp.Run := run;//13
            KanbanImp."Lead Time" := GetValueAtCell(RowNo, 14);
            KanbanImp.Vendor := GetValueAtCell(RowNo, 15);
            KanbanImp.Quotation := GetValueAtCell(RowNo, 16);
            KanbanImp."Unit Price" := UnitPrice;//17
            KanbanImp.PD := PDSelect;
            //Total 18
            KanbanImp.Revision := GetValueAtCell(RowNo, 19);
            KanbanImp."Zone No." := GetValueAtCell(RowNo, 20);
            KanbanImp."Shelf No." := GetValueAtCell(RowNo, 21);
            KanbanImp.Insert();
        end;


    end;

    procedure GetLastRowandColumn()
    begin
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        IF ExcelBuf1.GET(RowNo, ColNo) THEN BEGIN
            EXIT(ExcelBuf1."Cell Value as Text");
        END ELSE BEGIN
            //EVALUATE(ExcelBuf1,"Cell Value as Text");
        END;
    end;


}