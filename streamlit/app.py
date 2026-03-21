import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

session = get_active_session()

st.title("📊 Analyse des Offres d'Emploi LinkedIn")

tab1, tab2, tab3, tab4, tab5 = st.tabs([
    "🏆 Top 10 Titres",
    "💰 Top 10 Salaires",
    "🏢 Taille Entreprise",
    "🏭 Secteurs",
    "⏱️ Type d'emploi"
])

# --- Analyse 1 ---
with tab1:
    st.subheader("Top 10 des titres les plus publiés par industrie")
    industries = session.sql(
        "SELECT DISTINCT industry_id FROM job_industries ORDER BY 1"
    ).to_pandas()
    industry = st.selectbox("Choisir un secteur", industries["INDUSTRY_ID"], key="ind1")
    df1 = session.sql(f"""
        SELECT jp.title, COUNT(*) AS nb_offres
        FROM job_postings jp
        JOIN job_industries ji ON jp.job_id = ji.job_id
        WHERE ji.industry_id = '{industry}'
        GROUP BY jp.title
        ORDER BY nb_offres DESC
        LIMIT 10
    """).to_pandas()
    st.bar_chart(df1.set_index("TITLE")["NB_OFFRES"])

# --- Analyse 2 ---
with tab2:
    st.subheader("Top 10 des postes les mieux rémunérés par industrie")
    industries2 = session.sql(
        "SELECT DISTINCT industry_id FROM job_industries ORDER BY 1"
    ).to_pandas()
    industry2 = st.selectbox("Choisir un secteur", industries2["INDUSTRY_ID"], key="ind2")
    df2 = session.sql(f"""
        SELECT jp.title, ROUND(AVG(jp.max_salary), 0) AS avg_max_salary
        FROM job_postings jp
        JOIN job_industries ji ON jp.job_id = ji.job_id
        WHERE ji.industry_id = '{industry2}'
        AND jp.pay_period = 'YEARLY'
        AND jp.max_salary IS NOT NULL
        GROUP BY jp.title
        ORDER BY avg_max_salary DESC
        LIMIT 10
    """).to_pandas()
    st.bar_chart(df2.set_index("TITLE")["AVG_MAX_SALARY"])

# --- Analyse 3 ---
with tab3:
    st.subheader("Répartition des offres par taille d'entreprise")
    df3 = session.sql("""
        SELECT
            CASE c.company_size
                WHEN 0 THEN '0 - Très petite'
                WHEN 1 THEN '1 - Petite'
                WHEN 2 THEN '2 - Petite-Moyenne'
                WHEN 3 THEN '3 - Moyenne'
                WHEN 4 THEN '4 - Grande-Moyenne'
                WHEN 5 THEN '5 - Grande'
                WHEN 6 THEN '6 - Très grande'
                WHEN 7 THEN '7 - Géante'
            END AS taille_label,
            COUNT(jp.job_id) AS nb_offres
        FROM job_postings jp
        JOIN companies c ON SPLIT_PART(jp.company_name, '.', 1) = c.company_id
        GROUP BY c.company_size, taille_label
        ORDER BY c.company_size
    """).to_pandas()
    st.bar_chart(df3.set_index("TAILLE_LABEL")["NB_OFFRES"])

# --- Analyse 4 ---
with tab4:
    st.subheader("Répartition des offres par secteur d'activité (Top 20)")
    df4 = session.sql("""
        SELECT ji.industry_id AS industry, COUNT(DISTINCT jp.job_id) AS nb_offres
        FROM job_postings jp
        JOIN job_industries ji ON jp.job_id = ji.job_id
        GROUP BY ji.industry_id
        ORDER BY nb_offres DESC
        LIMIT 20
    """).to_pandas()
    st.bar_chart(df4.set_index("INDUSTRY")["NB_OFFRES"])

# --- Analyse 5 ---
with tab5:
    st.subheader("Répartition des offres par type d'emploi")
    df5 = session.sql("""
        SELECT formatted_work_type AS type_emploi,
               COUNT(*) AS nb_offres,
               ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pourcentage
        FROM job_postings
        WHERE formatted_work_type IS NOT NULL
        GROUP BY formatted_work_type
        ORDER BY nb_offres DESC
    """).to_pandas()
    st.bar_chart(df5.set_index("TYPE_EMPLOI")["NB_OFFRES"])
    st.dataframe(df5)