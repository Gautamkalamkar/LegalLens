import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:hive_ce/hive.dart';
import 'package:legallens/pages/loading_page.dart';
import 'package:legallens/pages/results/contractsresult_page.dart';
import 'package:legallens/services/deepseek_service.dart';
import 'package:legallens/services/hive_service.dart';

class PdfviewerPage extends StatelessWidget {
  const PdfviewerPage(
      {super.key, required this.pdfPath, required this.docType});

  final String pdfPath;
  final String docType;
  final String contractsPrompt =
      "Analyze the provided legal document (agreement/contract) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of contract/agreement and, if possible, the industry or context it belongs to. Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as parties involved, main obligations, payment terms, termination clauses, and other critical provisions. Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks in the document. Prioritize risks based on their potential impact (e.g., financial, legal, operational) and likelihood. Present them in bullet points, with the highest priority risks first. Include the page number(s) where each risk statement is found in the document. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to mitigate or improve the identified risks. Tailor the suggestions to the specific risks and context of the document. "
      "5. **Tone and Format**: Use clear and simple language for readability. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user has no legal background and tailor the response for clarity and simplicity. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String courtDocsPrompt =
      "Analyze the provided legal document (plaint/petition, written statement, affidavit, memorandum of appeal, rejoinder/rebuttal, or interim application) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of court document, its purpose, and the legal context (e.g., civil, criminal, commercial, family law, etc.). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the nature of the dispute or claim, the relief sought, key arguments or defenses, and any critical procedural or substantive issues. Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., likelihood of success, procedural defects, evidentiary gaps, or adverse legal consequences) and likelihood. Present them in bullet points, with the highest priority risks first. Include the page number(s) or paragraph reference(s) where each risk is found in the document. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to arguments, additional evidence, procedural corrections, or strategic considerations. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both legal and non-legal audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String intellectualsPrompt =
      "Analyze the provided intellectual property document (Trademark Application, Patent Specification, Copyright Assignment Agreement, or Licensing Agreement) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of intellectual property document, its purpose, and the legal context (e.g., trademark registration, patent protection, copyright transfer, or licensing). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the intellectual property being protected or transferred, key terms (e.g., scope of rights, exclusivity, royalties, duration), and any critical provisions (e.g., warranties, indemnities, or dispute resolution). Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., loss of rights, financial liability, enforceability issues, or operational constraints) and likelihood. For each risk, provide the **exact clause or line** where the risk exists, along with the page number(s) or paragraph reference(s). Present risks in bullet points, with the highest priority risks first. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to clauses, additional protections, or clarifications to avoid ambiguity. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both legal and non-legal audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String financesPrompt =
      "Analyze the provided financial document (Loan Agreement, Debenture Trust Deed, Guarantee Agreement, or Security Agreement) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of financial document, its purpose, and the legal context (e.g., loan financing, debt security, guarantees, or collateral arrangements). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the principal financial terms (e.g., loan amount, interest rate, repayment schedule, security provided, or guarantees), and any critical provisions (e.g., events of default, covenants, enforcement mechanisms, or dispute resolution). Use simple, easy-to-understand language and avoid financial or legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., financial loss, breach of covenants, enforcement challenges, or collateral insufficiency) and likelihood. For each risk, provide the **exact clause or line** where the risk exists, along with the page number(s) or paragraph reference(s). Present risks in bullet points, with the highest priority risks first. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to clauses, additional safeguards, or clarifications to avoid ambiguity. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both financial and non-financial audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no financial or legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any financial or legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String corporatesPrompt =
      "Analyze the provided corporate or commercial document (Memorandum of Association, Articles of Association, Board Resolution, Share Purchase Agreement, Joint Venture Agreement, or Due Diligence Report) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of corporate or commercial document, its purpose, and the legal context (e.g., company formation, governance, share transactions, joint ventures, or due diligence). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the purpose of the document (e.g., company incorporation, governance rules, share transfer, joint venture terms, or due diligence findings), and any critical provisions (e.g., rights and obligations, decision-making processes, warranties, indemnities, or dispute resolution). Use simple, easy-to-understand language and avoid corporate or legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., governance issues, financial loss, breach of obligations, or enforceability challenges) and likelihood. For each risk, provide the **exact clause or line** where the risk exists, along with the page number(s) or paragraph reference(s). Present risks in bullet points, with the highest priority risks first. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to clauses, additional safeguards, or clarifications to avoid ambiguity. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both corporate and non-corporate audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no corporate or legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any corporate or legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String familiesPrompt =
      "Analyze the provided family or personal law document (Marriage Contract, Divorce Petition, Settlement Agreement, Adoption Deed, Will, Trust Deed, or Probate Application) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of family or personal law document, its purpose, and the legal context (e.g., marriage, divorce, child adoption, inheritance, or estate planning). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the purpose of the document (e.g., marriage terms, divorce terms, child adoption, asset distribution, or estate administration), and any critical provisions (e.g., financial arrangements, custody terms, inheritance distribution, or trustee responsibilities). Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., financial disputes, custody conflicts, inheritance challenges, or enforceability issues) and likelihood. For each risk, provide the **exact clause or line** where the risk exists, along with the page number(s) or paragraph reference(s). Present risks in bullet points, with the highest priority risks first. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to clauses, additional safeguards, or clarifications to avoid ambiguity. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both legal and non-legal audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String realEstatesPrompt =
      "Analyze the provided property or real estate document (Sale Deed, Conveyance Deed, Gift Deed, Mortgage Deed, Title Deed, or Development Agreement) and perform the following tasks: "
      "1. **Document Identification**: Understand the type of property or real estate document, its purpose, and the legal context (e.g., property transfer, mortgage, gift, or development). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the property details (e.g., location, area, and description), the nature of the transaction (e.g., sale, gift, mortgage, or development), and any critical provisions (e.g., payment terms, encumbrances, warranties, or dispute resolution). Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., title disputes, financial loss, encumbrances, or enforceability issues) and likelihood. For each risk, provide the **exact clause or line** where the risk exists, along with the page number(s) or paragraph reference(s). Present risks in bullet points, with the highest priority risks first. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to clauses, additional safeguards, or clarifications to avoid ambiguity. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both legal and non-legal audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  final String othersPrompt =
      "Analyze the provided legal document and perform the following tasks: "
      "1. **Document Identification**: Understand the type of legal document, its purpose, and the legal context (e.g., contractual, regulatory, transactional, or dispute-related). Use this understanding to tailor the analysis, but **do not explicitly generate a 'Document Type and Context' section in the response**. "
      "2. **High-Level Summary**: Write the entire summary in one concise paragraph. Focus on key elements such as the parties involved, the purpose of the document, the main obligations or rights, and any critical provisions (e.g., payment terms, termination clauses, dispute resolution, or warranties). Use simple, easy-to-understand language and avoid legal jargon unless briefly explained. "
      "3. **Risk Identification**: Identify and list all significant risks or weaknesses in the document. Prioritize risks based on their potential impact (e.g., financial, legal, operational, or reputational) and likelihood. For each risk, provide the **exact clause or line** where the risk exists, along with the page number(s) or paragraph reference(s). Present risks in bullet points, with the highest priority risks first. "
      "4. **Risk Mitigation Suggestions**: Provide actionable suggestions to address or mitigate the identified risks. Tailor the suggestions to the specific risks and context of the document. For example, suggest amendments to clauses, additional safeguards, or clarifications to avoid ambiguity. "
      "5. **Tone and Format**: Use clear and professional language for readability, ensuring the analysis is accessible to both legal and non-legal audiences. Structure the response as follows: "
      "   - Start the **summary** with the marker `[SUMMARY]`. "
      "   - Start the **risk identification** section with the marker `[RISKS]`. "
      "   - Start the **mitigation suggestions** section with the marker `[MITIGATIONS]`. "
      "6. **Audience**: Assume the user may have no legal background and tailor the response for clarity and simplicity. Avoid overly technical language unless necessary, and briefly explain any legal terms or concepts used. "
      "7. **Additional Instructions**: "
      "   - **Do not include any headings or subheadings in the response**. "
      "   - **Do not generate a 'Document Type and Context' section**. Use the understanding of the document type and context to inform the analysis, but do not explicitly state it in the output. "
      "   - Ensure the summary, risks, and mitigations are clearly separated by their respective markers.";

  String _getPromptForDocType(String docType) {
    switch (docType) {
      case 'contracts':
        return contractsPrompt;
      case 'courtDocs':
        return courtDocsPrompt;
      case 'intellectuals':
        return intellectualsPrompt;
      case 'finances':
        return financesPrompt;
      case 'corporates':
        return corporatesPrompt;
      case 'families':
        return familiesPrompt;
      case 'realEstates':
        return realEstatesPrompt;
      default:
        return othersPrompt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('documentsBox');
    final HiveService hiveService = HiveService();
    final String text = hiveService.retrieveTextFromHive(box, pdfPath, docType);
    return Scaffold(
        body: PDFView(
          filePath: pdfPath,
          fitEachPage: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoadingPage()),
              );

              // Call the API in the background
              final response = await DeepseekService()
                  .accessDeepseek(text, _getPromptForDocType(docType));

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ContractsresultPage(response: response),
                ),
              );
            },
            label: Text('Process PDF')));
  }
}
