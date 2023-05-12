report 50000 "Inventory Valuation by Lot"
{
    // #
    DefaultLayout = RDLC;
    RDLCLayout = './.src/ReportLaout/InventoryValuationbyLot.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;
    Caption = 'Inventory By Lot';


    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Location Filter", "Inventory Posting Group";
            column(InventoryPostingGroup; Item."Inventory Posting Group")
            {
            }
            column(Description; Item.Description)
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(AsOfDate; AsOfdate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(SortA; Sort001)
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", "Location Code", Open, "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.") ORDER(Ascending) WHERE("Remaining Quantity" = FILTER(> 0));
                column(Location; LocationC)
                {
                }
                column(PostingDate; "Item Ledger Entry"."Posting Date")
                {
                }
                column(LotNo; "Item Ledger Entry"."Lot No.")
                {
                }
                column(Row11; Row11)
                {
                }
                column(EntryNo; "Entry No.")
                {
                }
                column(RemainingQuantity; "Item Ledger Entry"."Remaining Quantity")
                {
                }
                column(ItemNo; "Item Ledger Entry"."Item No.")
                {
                }
                column(LocationCode; "Item Ledger Entry"."Location Code")
                {
                }
                column(Quantity_ItemLedgerEntry; "Item Ledger Entry"."Remaining Quantity")
                {
                }
                column(RunN; RunN)
                {
                }
                column(DocNo; "Item Ledger Entry"."Document No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    QtyUse: Decimal;
                    CostUse: Decimal;
                    ItemLedger2: Record "Item Ledger Entry";
                    PHOrder: Record "Purchase Header";
                    PHLine: Record "Purchase Line";
                    PurReceiveH: Record "Purch. Rcpt. Header";
                    PurInvLine: Record "Purch. Inv. Line";
                    PurReceiveL: Record "Purch. Rcpt. Line";
                    SalesInvLine: Record "Sales Invoice Line";
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesShipmentL: Record "Sales Shipment Line";
                    ValueEntryLedger: Record "Value Entry";
                    CostUse2: Decimal;
                    SumQtyBG: Decimal;
                    CostA: Decimal;
                    CostB: Decimal;
                begin
                    RunN += 1;
                    Row11 += 1;
                    LocationC := "Item Ledger Entry"."Location Code";

                    /*
                    IF LocationA<>LocationC THEN
                      BEGIN
                        LocationA:=LocationC;
                        AmountBL:=0;
                        QtyBL:=0;
                        PcsIn:=0;
                        CountItem:=0;
                        BGAmount:=0;
                        BGQty:=0;
                        BGUnit:=0;
                      END;
                    
                      //เพื่อหาว่าเริ่มต้น Stock เท่าไหร่//
                    IF CountItem=0 THEN
                      BEGIN
                          CountItem+=1;
                          CostUse:=0;
                          CostUse2:=0;
                          SumQtyBG:=0;
                          ItemLedger.RESET;
                          ItemLedger.SETRANGE("Item No.",Item."No.");
                          ItemLedger.SETFILTER("Posting Date",'..%1',CALCDATE('<-1D>',AsOfdate));
                          ItemLedger.SETRANGE("Location Code","Item Ledger Entry"."Location Code");
                          IF ItemLedger.FIND('-') THEN
                             BEGIN
                               REPEAT
                                  CostA:=0;
                                  CostB:=0;
                                  SumQtyBG+=ItemLedger.Quantity;
                                  ValueEntryLedger.RESET;
                                  ValueEntryLedger.SETRANGE("Item Ledger Entry No.",ItemLedger."Entry No.");
                                  ValueEntryLedger.SETRANGE("Location Code",LocationC);
                                  IF ValueEntryLedger.FIND('-') THEN
                                     BEGIN
                                        REPEAT
                                          CostA+=ValueEntryLedger."Cost Amount (Actual)";
                                          CostB+=ValueEntryLedger."Cost Amount (Expected)";
                                        UNTIL ValueEntryLedger.NEXT=0;
                                     END;
                                     IF CostA=0 THEN
                                          CostA:=CostB;
                    
                                     CostUse+=CostA;
                    
                               UNTIL ItemLedger.NEXT=0;
                               ///Calculate//
                               //IF CostUse=0 THEN
                                //      CostUse:=CostUse2;
                                  BGQty:=SumQtyBG;
                                  BGAmount:=CostUse;
                                  IF BGQty>0 THEN
                                      BGUnit:=(CostUse/BGQty);
                             END;
                      END;
                    
                    QtyUse:=0;
                    CostUse:=0;
                    CostUse2:=0;
                    Ref1:='';
                    Ref2:='';////pmentDate:="Item Ledger Entry"."Posting Date";
                    QtyIn:=0;
                    PcsIn:=0;
                    AmountIn:=0;
                    QtyOut:=0;
                    PcsOut:=0;
                    AmountOut:=0;
                    DTDDate:=0D;
                    VocherNo:='';
                    Row11:=0;
                    //////////////////////////////////////////////////////////BEGIN///////////////////////////////////////////
                    IF ("Item Ledger Entry"."Posting Date">=AsOfdate) AND ("Item Ledger Entry"."Posting Date"<=EndDate) THEN
                    BEGIN
                    Row11:=1;
                    QtyUse:=0;
                    CostUse:=0;
                    CostUse2:=0;
                    Ref1:='';
                    Ref2:='';////pmentDate:="Item Ledger Entry"."Posting Date";
                    QtyIn:=0;
                    PcsIn:=0;
                    AmountIn:=0;
                    QtyOut:=0;
                    PcsOut:=0;
                    AmountOut:=0;
                    DTDDate:="Item Ledger Entry"."Posting Date";
                    VocherNo:="Item Ledger Entry"."Document No.";
                    
                    
                    IF "Item Ledger Entry"."Document Type"="Item Ledger Entry"."Document Type"::"Purchase Receipt" THEN
                        BEGIN
                            PurReceiveH.RESET;
                            PurReceiveH.SETRANGE("No.","Item Ledger Entry"."Document No.");
                            IF PurReceiveH.FIND('-') THEN
                               BEGIN
                    
                    
                                 PurReceiveL.RESET;
                                 PurReceiveL.SETRANGE("Document No.",PurReceiveH."No.");
                                 PurReceiveL.SETRANGE("No.","Item Ledger Entry"."Item No.");
                                 PurReceiveL.SETRANGE("Line No.","Item Ledger Entry"."Document Line No.");
                                 IF PurReceiveL.FIND('-') THEN
                                   BEGIN
                                     Ref2:=PurReceiveL."Order No.";
                                     PurReceiveH.RESET;
                    
                                        PurInvLine.RESET;
                                        PurInvLine.SETRANGE("Receipt No.",PurReceiveH."No.");
                                        PurInvLine.SETRANGE("No.","Item Ledger Entry"."Item No.");
                                        PurInvLine.SETRANGE("Order No.",PurReceiveH."Order No.");
                                        PurInvLine.SETRANGE("Order Line No.","Item Ledger Entry"."Document Line No.");
                                        IF PurInvLine.FIND('-') THEN
                                           BEGIN
                                              PurInvLine.CALCFIELDS("External No.","External Date");
                                              Ref1:=PurInvLine."External No.";
                                              DTDDate:=PurInvLine."External Date";
                    
                                                  ValueEntryLedger.RESET;
                                                  ValueEntryLedger.SETRANGE("Item Ledger Entry No.","Item Ledger Entry"."Entry No.");
                                                  ValueEntryLedger.SETRANGE("Document Type",ValueEntryLedger."Document Type"::"Purchase Invoice");
                                                  IF ValueEntryLedger.FIND('-') THEN
                                                     BEGIN
                                                          VocherNo:='';
                                                          REPEAT
                                                                IF VocherNo='' THEN
                                                                     VocherNo:=ValueEntryLedger."Document No.";
                                                          UNTIL ValueEntryLedger.NEXT=0;
                                                     END;
                    
                                           END;
                                  END;
                               END;
                        END;
                    IF "Item Ledger Entry"."Document Type"="Item Ledger Entry"."Document Type"::"Sales Shipment" THEN
                        BEGIN
                            VocherNo:='';
                            Ref2:="Item Ledger Entry"."External Document No.";
                            ValueEntryLedger.RESET;
                            ValueEntryLedger.SETRANGE("Item Ledger Entry No.","Item Ledger Entry"."Entry No.");
                            ValueEntryLedger.SETRANGE("Document Type",ValueEntryLedger."Document Type"::"Sales Invoice");
                            IF ValueEntryLedger.FIND('-') THEN
                               BEGIN
                                  REPEAT
                                    IF VocherNo='' THEN
                                      BEGIN
                                         VocherNo:=ValueEntryLedger."Document No.";
                                         Ref1:=VocherNo;
                                         DTDDate:=ValueEntryLedger."Posting Date";
                                      END;
                                  UNTIL ValueEntryLedger.NEXT=0;
                               END;
                               IF VocherNo='' THEN
                                    VocherNo:="Item Ledger Entry"."Document No.";
                    
                               {
                            SalesShipmentL.RESET;
                            SalesShipmentL.SETRANGE("Line No.","Item Ledger Entry"."Document Line No.");
                            SalesShipmentL.SETRANGE("Document No.","Item Ledger Entry"."Document No.");
                            IF SalesShipmentL.FIND('-') THEN
                               BEGIN
                    
                               END;
                               }
                        END;
                    
                    IF ("Item Ledger Entry"."Entry Type"="Item Ledger Entry"."Entry Type"::Output) OR ("Item Ledger Entry"."Entry Type"="Item Ledger Entry"."Entry Type"::Consumption)THEN
                        BEGIN
                          IF Ref2='' THEN
                             BEGIN
                                Ref2:="Item Ledger Entry"."Lot No.";
                             END;
                       END;
                    //Calculate Balance//
                    IF "Item Ledger Entry".Quantity>0 THEN
                         BEGIN
                            CostUse:=0;
                            CostUse2:=0;
                            ValueEntryLedger.RESET;
                            ValueEntryLedger.SETRANGE("Item Ledger Entry No.","Item Ledger Entry"."Entry No.");
                            IF ValueEntryLedger.FIND('-') THEN
                               BEGIN
                                  REPEAT
                                    CostUse+=ValueEntryLedger."Cost Amount (Actual)";
                                    CostUse2+=ValueEntryLedger."Cost Amount (Expected)";
                                  UNTIL ValueEntryLedger.NEXT=0;
                               END;
                            IF CostUse=0 THEN
                               CostUse:=CostUse2;
                            CostUse:=(CostUse/"Item Ledger Entry".Quantity);
                            QtyIn:="Item Ledger Entry".Quantity;
                            PcsIn:=CostUse;
                            AmountIn:=QtyIn*CostUse;
                            //////BL/////////
                            IF CountItem=1 THEN
                             BEGIN
                                  QtyBL:=QtyBL+QtyIn+BGQty;
                                  AmountBL:=AmountBL+AmountIn+BGAmount;
                                  CountItem+=1;
                             END
                             ELSE
                              BEGIN
                                QtyBL:=QtyBL+QtyIn;
                                AmountBL:=AmountBL+AmountIn;
                               // MESSAGE(FORMAT(QtyIn)+'=='+FORMAT(QtyBL));
                              END;
                    
                    
                            IF QtyBL>0 THEN
                                  PcsBL:=(AmountBL/QtyBL);
                         END;
                    IF "Item Ledger Entry".Quantity<0 THEN
                        BEGIN
                            CostUse:=0;
                            CostUse2:=0;
                            ValueEntryLedger.RESET;
                            ValueEntryLedger.SETRANGE("Item Ledger Entry No.","Item Ledger Entry"."Entry No.");
                            IF ValueEntryLedger.FIND('-') THEN
                               BEGIN
                                  REPEAT
                                    CostUse+=ValueEntryLedger."Cost Amount (Actual)";
                                    CostUse2+=ValueEntryLedger."Cost Amount (Expected)";
                                  UNTIL ValueEntryLedger.NEXT=0;
                               END;
                    
                           IF CostUse=0 THEN
                               CostUse:=CostUse2;
                           CostUse:=(CostUse/"Item Ledger Entry".Quantity);
                           QtyOut:="Item Ledger Entry".Quantity*-1;
                           PcsOut:=CostUse;
                           AmountOut:=QtyOut*CostUse;
                           //////BL/////////
                          IF CountItem=1 THEN
                             BEGIN
                    
                                  QtyBL:=(QtyBL+BGQty)-QtyOut;
                                  AmountBL:=(AmountBL+BGAmount)-AmountOut;
                                  CountItem+=1;
                             END
                             ELSE
                              BEGIN
                                QtyBL:=QtyBL-QtyOut;
                                AmountBL:=AmountBL-AmountOut;
                    
                              END;
                    
                            IF QtyBL>0 THEN
                                  PcsBL:=(AmountBL/QtyBL);
                    
                    
                    
                        END;
                    
                    
                      IF AmountBL=0 THEN
                          PcsBL:=0;
                    //////////////////////////////////////////////////////////////////////END//////////////////////////////////////////////
                    END;
                    */

                end;

                trigger OnPreDataItem()
                var
                    SumM: Decimal;
                begin
                    RunN := 0;
                    Row11 := 0;
                    SetFilter("Posting Date", '..%1', AsOfdate);
                    if Item.GetFilter("Location Filter") <> '' then
                        SetRange("Location Code", Item.GetFilter("Location Filter"));
                end;
            }

            trigger OnAfterGetRecord()
            var
                SumM: Decimal;
            begin
                QtyBL := 0;
                PcsBL := 0;
                AmountBL := 0;
                Sort001 += 1;
                BGAmount := 0;
                BGQty := 0;
                BGUnit := 0;
                SumM := 0;
                CountItem := 0;


                ItemLedger.Reset;
                ItemLedger.SetFilter("Posting Date", '..%1', AsOfdate);
                ItemLedger.SetRange("Item No.", Item."No.");
                if Item.GetFilter("Location Filter") <> '' then
                    ItemLedger.SetRange("Location Code", Item.GetFilter("Location Filter"));
                if ItemLedger.Find('-') then begin
                    repeat
                        SumM += ItemLedger.Quantity;
                    until ItemLedger.Next = 0;
                end;

                if SumM <= 0 then
                    CurrReport.Skip;

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(AsOfdate; AsOfdate)
                {
                    Caption = 'As of Date';
                    ApplicationArea = all;
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date';
                    Visible = false;
                    ApplicationArea = all;
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            AsOfdate := CalcDate('<CM>', Today);
        end;
    }

    labels
    {
    }

    var
        AsOfdate: Date;
        QtyIn: Decimal;
        QtyOut: Decimal;
        QtyBL: Decimal;
        PcsIn: Decimal;
        PcsOut: Decimal;
        PcsBL: Decimal;
        AmountIn: Decimal;
        AmountOut: Decimal;
        AmountBL: Decimal;
        ItemS: Record Item;
        ItemLedger: Record "Item Ledger Entry";
        Ref1: Text[50];
        Ref2: Text[50];
        ShipmentDate: Date;
        DTDDate: Date;
        VocherNo: Text[50];
        LocationC: Code[30];
        LocationA: Code[30];
        Sort001: Integer;
        EndDate: Date;
        BGQty: Decimal;
        BGUnit: Decimal;
        BGAmount: Decimal;
        CountItem: Integer;
        Row11: Integer;
        RunN: Integer;
        DocNo: Text[50];
}

