report 50003 "Purchase Request"
{
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/PurchaseRequest.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    PreviewMode = Normal;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Quote));
            column(No_; "No.") { }
            column(Requested_Receipt_Date; "Requested Receipt Date") { }
            column(Purchaser_Code; utility.getNameSalesPeson("Purchase Header"."Shortcut Dimension 2 Code")) { }
            column(com_name; Comp.Name) { }
            column(com_address1; Comp.Address) { }
            column(com_address2; Comp."Address 2") { }
            column(com_phone; Comp."Phone No.") { }
            column(com_fax; Comp."Fax No.") { }
            column(com_VatRegit; Comp."VAT Registration No.") { }
            column(Ship_to_Name; Comp."Ship-to Name") { }
            column(Ship_to_Address1; Comp."Ship-to Address") { }
            column(Ship_to_Address2; Comp."Ship-to Address 2") { }
            column(ship_to_Phone; Comp."Ship-to-Phone") { }
            column(Ship_to_Fax; Comp."Ship-to-Fax") { }
            column(Ship_to_branch; Comp."Ship-to-Branch") { }

            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; VName) { }
            column(Buy_from_Address; Vend.Address) { }
            column(Buy_from_Address2; Vend."Address 2") { }
            column(Buy_from_Address3; Vend."Address 3") { }
            column(Cancel_Date; "Cancel Date") { }
            column(Document_Date; "Document Date") { }
            column(Dept; "Purchase Header"."Shortcut Dimension 1 Code") { }
            column(Person; utility.getNameSalesPeson("Purchase Header"."Shortcut Dimension 2 Code")) { }
            column(issueDate; "Purchase Header"."Document Date") { }
            column(ShipVia; "Purchase Header"."Shipment Method Code") { }
            column(FOBPoint; "Purchase Header"."FOB Point") { }
            column(paymetTerm; PaymentT.Description) { }
            column(paymentMethodD; PaymentMethod.Description) { }
            // column(Quote_No_; "Quote No.") { }
            column(m_Remark1; m_Remark1) { }
            column(m_Remark2; m_Remark2) { }
            column(m_Remark3; m_Remark3) { }
            column(m_Remark4; m_Remark4) { }
            column(ApName; ApName) { }
            column(VATPer; VATPer) { }
            column(SubTotal; SubTotal) { }
            column(VatTotal; VatTotal) { }
            column(ShippingTotal; ShippingTotal) { }
            column(Other; Other) { }
            column(GrandTotal; GrandTotal) { }
            column(CRNo; CRNo) { }
            column(Curr; Curr) { }
            column(BOI_Code; "BOI Code") { }


            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = where("PO Status" = filter('Open'));
                column(RNo; RNo) { }
                column(Item_no; "Purchase Line"."No.") { }
                column(Description; desc) { }
                column(Description_2; "Description 2") { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Amount; Amount) { }
                column(Line_Amount; "Line Amount") { }
                column(ReqDate; "Purchase Line"."Expected Receipt Date") { }
                column(Item_Category_Code; "Purchase Line".Classification) { }
                column(Supplier_Name; "Supplier Name") { }
                column(Maker; Maker) { }
                column(LeadTime; LeadTime) { }
                column(desc2; desc2) { }
                column(Quote_No_; "Quote No.") { }
                column(Model; Model) { }
                column(ClassCode; ClassCode) { }
                ///
                trigger OnAfterGetRecord()
                begin
                    ClassCode := '';
                    desc2 := '';
                    if ("Purchase Line"."No." <> '') then begin
                        //CsNo += 1;
                        RNo += 1;
                        ;
                        if (VATPer = '') then begin
                            if ("Purchase Line"."VAT %" > 0) then
                                VATPer := Format("Purchase Line"."VAT %") + '%'
                        end;
                    end;



                    desc := Description;
                    ItemS.Reset();
                    ItemS.SetRange("No.", "Purchase Line"."No.");
                    //  ItemS.SetFilter("Vendor Item No.", '<>%1', '');
                    if (ItemS.Find('-')) then begin
                        if (ItemS."Vendor Item No." <> '') then
                            desc := ItemS."Vendor Item No.";
                        desc2 := ItemS."Description 2";
                        //  Model:=ItemS.m
                        Maker := ItemS.Maker;
                        //LeadTime := ItemS."Lead Time Calculation";
                        if "Purchase Line".Classification = '' then
                            "Purchase Line".Classification := ItemS.Classification;

                    end;

                    Classfica.Reset();
                    Classfica.SetRange("No.", "Purchase Line".Classification);
                    if Classfica.Find('-') then
                        ClassCode := Classfica.Code;


                end;
            }


            trigger OnAfterGetRecord()
            begin
                Vend.Reset();
                Vend.SetRange("No.", "Purchase Header"."Buy-from Vendor No.");
                if Vend.Find('-') then begin
                    VName := Vend.Name;
                    if NameThai then
                        VName := Vend."Name TH";
                end;

                PaymentT.Reset();
                PaymentT.SetRange(Code, "Purchase Header"."Payment Terms Code");
                if PaymentT.Find('-') then;

                PaymentMethod.Reset();
                PaymentMethod.SetRange(Code, "Purchase Header"."Payment Method Code");
                if PaymentMethod.Find('-') then;


                CRNo := 0;
                PurL.Reset();
                PurL.SetRange("Document No.", "Purchase Header"."No.");
                PurL.SetRange("Document Type", "Purchase Header"."Document Type");
                if PurL.Find('-') then begin
                    repeat
                        if PurL.Description <> '' then
                            CRNo += 1;

                    until PurL.Next = 0;
                end;



                CKNo := 0;
                tblPurComment.Reset();
                tblPurComment.SetRange("No.", "Purchase Header"."No.");
                tblPurComment.SetFilter(Comment, '<>%1', '');
                if tblPurComment.Find('-') then begin
                    repeat
                        CKNo += 1;
                        if CKNo = 1 then
                            m_Remark1 := tblPurComment.Comment;
                        if CKNo = 2 then
                            m_Remark2 := tblPurComment.Comment;
                        if CKNo = 3 then
                            m_Remark3 := tblPurComment.Comment;
                        if CKNo = 4 then
                            m_Remark4 := tblPurComment.Comment;
                    until tblPurComment.Next = 0;
                end;
                //app//
                approveEntry.Reset();
                approveEntry.SetRange("Document No.", "Purchase Header"."No.");
                approveEntry.SetRange(Status, approveEntry.Status::Approved);
                if approveEntry.Find('-') then begin
                    ApName := utility.UserFullName(approveEntry."Approver ID");
                end;

                //Total//
                //VatTotal:="Purchase Header".am
                "Purchase Header".CalcFields("Amount Including VAT");
                "Purchase Header".CalcFields(Amount);
                GrandTotal := "Purchase Header"."Amount Including VAT";
                SubTotal += "Purchase Header".Amount;
                VatTotal := GrandTotal - SubTotal;
                Curr := "Purchase Header"."Currency Code";
                if Curr = '' then
                    Curr := 'THB';


            end;
        }
    }
    requestpage
    {

    }
    trigger OnPreReport()
    begin
        gCRLF[1] := 10;
        gCRLF[2] := 13;
        RNo := 0;

        SubTotal := 0;
        GrandTotal := 0;
        VatTotal := 0;

        Comp.get();
        ApName := '';


    end;

    var
        IssueBy: Text;
        Comp: Record "Company Information";
        Vend: Record Vendor;
        Classfica: Record CLASSFICATION;
        VName: Text;
        NameThai: Boolean;
        Curr: Text;
        PaymentT: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        tblPurComment: Record "Purch. Comment Line";
        PurL: Record "Purchase Line";
        m_Remark1: Text[250];
        m_Remark2: Text[250];
        m_Remark3: Text[250];
        m_Remark4: Text[250];
        ClassCode: Code[10];
        Model: Text[50];
        gCRLF: Text;
        RNo: Integer;
        CsNo: Integer;
        CRNo: Integer;
        CKNo: Integer;
        approveEntry: Record "Approval Entry";
        ApName: Text;
        utility: Codeunit Utility;
        desc: Text;
        desc2: Text;
        Maker: Text;
        LeadTime: Text;
        ItemS: Record Item;
        VATPer: Text;
        SubTotal: Decimal;
        VatTotal: Decimal;
        GrandTotal: Decimal;
        ShippingTotal: Decimal;
        Other: Decimal;
}