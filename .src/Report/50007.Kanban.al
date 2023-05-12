report 50007 "Kanban Report"
{
    PreviewMode = Normal;
    Caption = 'Kanban';
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/Kanban.rdlc';
    PdfFontEmbedding = Yes;
    dataset
    {
        dataitem("Kanban List"; "Kanban List")
        {
            RequestFilterFields = "Master No.";
            DataItemTableView = where("Part No." = filter(<> ''));
            column(Master_No_; "Master No.") { }
            column(Seq; Seq) { }
            column(Part_No_; "Part No.") { }
            column(Part_Name; "Part Name") { }
            column(Maker; Maker) { }
            column(Classification; Classification) { }
            column(Location; Location) { }
            column(Address; Address) { }
            column(Tool_; "Tool#") { }
            column(Process; Process) { }
            column(Note; Note) { }
            column(Picture; ItemS.Picture) { }
            column(Model; Model) { }
            column(Description; Items.Description) { }
            column(Qty; Qty) { }
            column(Run; Run) { }
            column(Lead_Time; "Lead Time") { }
            column(CDetail; CDetail) { }
            dataitem(Integer; Integer)
            {
                column(Number; Number) { }
                column(Barcode; EnCodeStr) { }
                column(Barcode2; Barcode) { }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, "Kanban List".Run);
                end;

                trigger OnAfterGetRecord()
                var
                    BarcodeInf: Interface "Barcode Font Provider";
                    Bsymblo: Enum "Barcode Symbology";
                begin
                    //SetFilter(Number, 1, "Kanban List".Run);
                    EnCodeStr := '';
                    // Barcode := '*1234*';
                    Barcode := '*' + Format("Kanban List"."Master No.") + '/' + Format(Number) + '*';
                    // BarcodeInf := Enum::"Barcode Font Provider"::IDAutomation1D;
                    // Bsymblo := Enum::"Barcode Symbology"::Code39;
                    // BarcodeInf.ValidateInput(Barcode, Bsymblo);
                    // EnCodeStr := BarcodeInf.EncodeFont(Barcode, Bsymblo);

                end;
            }
            //on Kanban List
            trigger OnAfterGetRecord()
            var

                classfi: Record CLASSFICATION;
            begin
                ItemS.Reset();
                ItemS.Get("Part No.");
                // ItemS.CalcFields(Picture);
                //Classfication//
                CDetail := '';
                classfi.Reset();
                classfi.SetRange("No.", "Kanban List".Classification);
                if classfi.Find('-') then
                    CDetail := classfi.Code;
            end;

        }

    }
    trigger OnPreReport()
    begin

    end;

    var
        ItemS: Record Item;
        utility: Codeunit Utility;
        Barcode: Code[30];
        EnCodeStr: Text;
        CDetail: Text;
        RowS: Integer;
        IDBarcode: Codeunit "BarCode Management";

}